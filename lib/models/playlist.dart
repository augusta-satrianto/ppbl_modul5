import 'package:flutter/foundation.dart';

class PlaylistModel {
  static List<Lagu> daftarLagu = [
    const Lagu(1, "Tulus", "Hati-hati di Jalan", "assets/cover/tulus.jpg"),
    const Lagu(2, "Dewa 19", "Satu", "assets/cover/dewa.jpg"),
    const Lagu(3, "Pamungkas", "Kenangan Manis", "assets/cover/pamungkas.jpg"),
  ];
}


@immutable
class Lagu {
  final int id;
  final String? artis;
  final String? judul;
  final String? _imagePath;

  const Lagu(this.id, this.artis, this.judul, this._imagePath);

  @override
  int get hashCode => id;

  @override
  bool operator == (Object other) => other is Lagu && other.id == id;

  String get imagePath => _imagePath == null ? 'assets/cover/music-placeholder.png' : _imagePath!;
}


