import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'mahasiswa.dart';

Future<Database> openMyDatabase() async {
  final _databaseName = "myDatabase.db";
  final _databaseVersion = 3;

  final table = 'mahasiswa';
  final columnId = '_id';
  final columnName = 'name';
  final columnAge = 'age';

  final tableDosen = 'dosen';
  final dosenId = '_id';
  final dosenName = 'name';
  final dosenNim = 'nim';

  final tableSaham = 'saham';
  final sahamTickerId = 'tickerid';
  final sahamTicker = 'ticker';
  final sahamOpen = 'open';
  final sahamHigh = 'high';
  final sahamLast = 'last';
  final sahamChange = 'change';
  final sahamJumlah = 'jumlah';

  final tableTransaksi = 'transaksi';
  final transaksiId = 'transaksiid';
  final transaksiTickerId = 'tickerid';
  final transaksiJumlah = 'jumlah_transaksi';
  final transaksiJenis = 'jenis_transaksi';

  final dbPath = await getDatabasesPath();
  final path = join(dbPath, _databaseName);
  final database = await openDatabase(
    path,
    version: _databaseVersion,
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute('''
          CREATE TABLE $tableDosen (
            $dosenId INTEGER PRIMARY KEY,
            $dosenName TEXT NOT NULL,
            $dosenNim INTEGER NOT NULL
          )
        ''');
      }

      if (oldVersion < 3) {
        await db.execute('''
          CREATE TABLE $tableSaham (
            $sahamTickerId INTEGER PRIMARY KEY AUTOINCREMENT,
            $sahamTicker TEXT NOT NULL,
            $sahamOpen INTEGER,
            $sahamHigh INTEGER,
            $sahamLast INTEGER,
            $sahamChange REAL,
            $sahamJumlah INTEGER NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE $tableTransaksi (
            $transaksiId INTEGER PRIMARY KEY AUTOINCREMENT,
            $transaksiTickerId INTEGER NOT NULL,
            $transaksiJumlah INTEGER NOT NULL,
            $transaksiJenis INTEGER NOT NULL CHECK($transaksiJenis IN (0, 1)),
            FOREIGN KEY ($transaksiTickerId) REFERENCES $tableSaham($sahamTickerId)
          )
        ''');
      }
    },
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $table (
          $columnId INTEGER PRIMARY KEY,
          $columnName TEXT NOT NULL,
          $columnAge INTEGER NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE $tableDosen (
          $dosenId INTEGER PRIMARY KEY,
          $dosenName TEXT NOT NULL,
          $dosenNim INTEGER NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE $tableSaham (
          $sahamTickerId INTEGER PRIMARY KEY AUTOINCREMENT,
          $sahamTicker TEXT NOT NULL,
          $sahamOpen INTEGER,
          $sahamHigh INTEGER,
          $sahamLast INTEGER,
          $sahamChange REAL,
          $sahamJumlah INTEGER NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE $tableTransaksi (
          $transaksiId INTEGER PRIMARY KEY AUTOINCREMENT,
          $transaksiTickerId INTEGER NOT NULL,
          $transaksiJumlah INTEGER NOT NULL,
          $transaksiJenis INTEGER NOT NULL CHECK($transaksiJenis IN (0, 1)),
          FOREIGN KEY ($transaksiTickerId) REFERENCES $tableSaham($sahamTickerId)
        )
      ''');
    },
  );
  return database;
}

class DatabaseHandler {
  Future<Database> initializeDB() async {
    return openMyDatabase();
  }

  Future<List<Mahasiswa>> fetchMahasiswa() async {
    List<Mahasiswa> daftarMahasiswa = [];
    final db = await openMyDatabase();

    daftarMahasiswa = await db.query('mahasiswa').then((maps) {
      return List.generate(maps.length, (i) {
        return Mahasiswa(
          id: maps[i]['_id'] as int,
          name: maps[i]['name'] as String,
          age: maps[i]['age'] as int,
        );
      });
    });

    return daftarMahasiswa;
  }

  Future<void> insertMahasiswa(String name) async {
    final db = await openMyDatabase();
    await db.transaction((txn) async {
      await txn.insert('mahasiswa', {'name': name, 'age': 25});
    });
  }

  Future<void> hapusMahasiswa(int id) async {
    final db = await openMyDatabase();
    await db.transaction((txn) async {
      await txn.delete('mahasiswa', where: '_id = ?', whereArgs: [id]);
    });
  }

  Future<void> insertSaham({
    required String ticker,
    required int jumlah,
    int? open,
    int? high,
    int? last,
  }) async {
    final db = await openMyDatabase();
    await db.transaction((txn) async {
      await txn.insert('saham', {
        'ticker': ticker,
        'open': open,
        'high': high,
        'last': last,
        'jumlah': jumlah,
      });
    });
  }

  Future<List<Map<String, dynamic>>> fetchSaham() async {
    final db = await openMyDatabase();
    return await db.query('saham');
  }

  Future<void> hapusSaham(int tickerId) async {
    final db = await openMyDatabase();
    await db.transaction((txn) async {
      await txn.delete(
        'transaksi',
        where: 'tickerid = ?',
        whereArgs: [tickerId],
      );
      await txn.delete('saham', where: 'tickerid = ?', whereArgs: [tickerId]);
    });
  }

  Future<void> updateJumlahSaham(int tickerId, int jumlahBaru) async {
    final db = await openMyDatabase();
    await db.transaction((txn) async {
      await txn.update(
        'saham',
        {'jumlah': jumlahBaru},
        where: 'tickerid = ?',
        whereArgs: [tickerId],
      );
    });
  }

  Future<void> insertTransaksi({
    required int tickerId,
    required int jumlahTransaksi,
    required int jenisTransaksi,
  }) async {
    final db = await openMyDatabase();
    await db.transaction((txn) async {
      if (jenisTransaksi != 0 && jenisTransaksi != 1) {
        throw Exception('Jenis transaksi harus 0 (beli) atau 1 (jual)');
      }

      final sahamList = await txn.query(
        'saham',
        where: 'tickerid = ?',
        whereArgs: [tickerId],
      );

      if (sahamList.isEmpty) {
        throw Exception('Saham dengan tickerid $tickerId tidak ditemukan');
      }

      final saham = sahamList.first;
      final jumlahSaatIni = saham['jumlah'] as int;

      int jumlahBaru;
      if (jenisTransaksi == 0) {
        jumlahBaru = jumlahSaatIni + jumlahTransaksi;
      } else {
        if (jumlahSaatIni < jumlahTransaksi) {
          throw Exception('Stok saham tidak mencukupi untuk dijual');
        }
        jumlahBaru = jumlahSaatIni - jumlahTransaksi;
      }

      await txn.insert('transaksi', {
        'tickerid': tickerId,
        'jumlah_transaksi': jumlahTransaksi,
        'jenis_transaksi': jenisTransaksi,
      });

      await txn.update(
        'saham',
        {'jumlah': jumlahBaru},
        where: 'tickerid = ?',
        whereArgs: [tickerId],
      );
    });
  }

  Future<List<Map<String, dynamic>>> fetchTransaksi() async {
    final db = await openMyDatabase();
    return await db.rawQuery('''
      SELECT 
        t.transaksiid,
        t.tickerid,
        s.ticker,
        t.jumlah_transaksi,
        t.jenis_transaksi
      FROM transaksi t
      INNER JOIN saham s ON t.tickerid = s.tickerid
      ORDER BY t.transaksiid DESC
    ''');
  }

  Future<void> hapusTransaksi(int transaksiId) async {
    final db = await openMyDatabase();
    await db.transaction((txn) async {
      await txn.delete(
        'transaksi',
        where: 'transaksiid = ?',
        whereArgs: [transaksiId],
      );
    });
  }
}
