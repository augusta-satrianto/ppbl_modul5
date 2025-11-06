import '../models/preferensi.dart';
import 'package:flutter/material.dart';

class PlayerControl with ChangeNotifier{
  late Preference _preferences;

  bool? isRandom;
  bool? isShuffle;

  PlayerControl(this._preferences);

  Preference get preferences => _preferences;

  void setRandom(bool rand) {
     // Save to preferences
    isRandom = rand;
    notifyListeners();
  }

  void setShuffle(bool shuf) {
     // Save to preferences
    isShuffle = shuf;
    notifyListeners();
  }
}