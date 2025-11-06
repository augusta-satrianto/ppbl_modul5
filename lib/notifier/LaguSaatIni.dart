import 'package:provider/provider.dart';
import '../models/playlist.dart';
import 'package:flutter/material.dart';

class LaguSaatIniModel extends ChangeNotifier {
  late Lagu _saatIni;

  LaguSaatIniModel(this._saatIni);

  Lagu get saatIni => _saatIni;

  set saatIni(Lagu value) {
    _saatIni = value;
    notifyListeners();
  }
}