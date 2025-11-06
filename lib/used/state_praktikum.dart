import 'package:flutter/material.dart';
import 'package:ppbl/notifier/PlayerControl.dart';
import 'package:provider/provider.dart';
import 'package:ppbl/models/playlist.dart';
import 'package:ppbl/screens/player.dart';
import 'package:ppbl/notifier/LaguSaatIni.dart';
import 'package:ppbl/models/preferensi.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) =>
              LaguSaatIniModel(const Lagu(0, '', '',
                  'assets/cover/music-placeholder.png'))
          ),
          ChangeNotifierProvider(create: (_) =>
              PlayerControl(const Preference(false, false))
          ),
        ],
        child: Consumer<LaguSaatIniModel>(
            builder: (context, lagu, child){
              return MaterialApp(
                title: lagu.saatIni.judul,
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
                  useMaterial3: true,
                ),
                home: const FitPlayer(title: 'Pemutar Musik FIT'),
              );
            }
        )
    );
  }
}