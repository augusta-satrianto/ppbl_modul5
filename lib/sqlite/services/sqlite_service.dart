import 'dart:collection';

import 'package:ppbl/sqlite/models/social_media.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import '../models/influencer.dart';

Future<Database> _getDatabase() async {
  var databasesPath = await getDatabasesPath();
  var path = join(databasesPath, "socmed_profiles.sqlite3");

  // Cek apakah database sudah ada?
  var exists = await databaseExists(path);

  // Jika belum ada, salin dari direktori assets
  if (!exists) {
    print("Menyalin dari direktori assets");

    // Buat direktorinya
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    // Salin
    ByteData data =
        await rootBundle.load(url.join("assets", "socmed_profiles.sqlite3"));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes, flush: true);
  } else {
    print("Database sudah ada");
  }

  return await openDatabase(
    path,
    version: 1,
    readOnly: false,
    onConfigure: (db) async => {await db.execute('PRAGMA foreign_keys = ON')},
  );
}

class DatabaseHandler {
  Future<Database> initializeDB() async {
    return _getDatabase();
  }

  Future<void> insertInfluencer(List<Influencer> influencers) async {
    final db = await initializeDB();
    await db.transaction((txn) async {
      for (var inf in influencers) {
        inf.id = await txn.insert('influencers', inf.toMap());
        for (var element in inf.socialMedia) {
          element.influencerId = inf.id!;
          element.id = await txn.insert('social', element.toMap());
        }
      }
    });
  }

  Future<void> deleteInfluencer(int? id) async {
    final db = await initializeDB();
    await db.transaction((txn) async {
      await txn.delete('social', where: 'influencerId = ?', whereArgs: [id]);
      await txn.delete(
        'influencers',
        where: "id = ?",
        whereArgs: [id],
      );
    });
  }

  Future<void> updateInfluencer(Influencer influencer) async {
    final db = await initializeDB();
    await db.transaction((txn) async {
      await txn.update(
        'influencers',
        influencer.toMap(),
        where: "id = ?",
        whereArgs: [influencer.id],
      );
      await txn.delete('social',
          where: 'influencerId = ?', whereArgs: [influencer.id]);
      for (var element in influencer.socialMedia) {
        await txn.insert('social', element.toMap());
      }
    });
  }

  Future<List<Influencer>> retrieveInfluencers() async {
    const sql = '''
SELECT inf.id, inf.nickName, inf.realName, soc.network, soc.account, soc.influencerId 
FROM influencers as inf 
LEFT JOIN social as soc 
ON inf.id = soc.influencerId;
''';
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(sql);
    Set<Influencer> influencerSet = SplayTreeSet();
    for (var element in queryResult) {
      Influencer newInfluencer = Influencer.fromMap(element);
      SocialMedia sm = SocialMedia.fromMap(element);
      Influencer? existing = influencerSet.lookup(newInfluencer);
      // sm.influencerId == 0 jika kolom2 social bernilai NULL karena LEFT JOIN
      if (existing != null && sm.influencerId != 0) {
        existing.socialMedia.add(sm);
      } else if (sm.influencerId != 0){
        newInfluencer.socialMedia.add(sm);
        influencerSet.add(newInfluencer);
      } else {
        influencerSet.add(newInfluencer);
      }
    }
    return influencerSet.toList();
  }
}
