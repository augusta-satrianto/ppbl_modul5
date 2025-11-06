class Mahasiswa{
  final int id;
  final String name;
  final int age;

  Mahasiswa({required this.id, required this.name, required this.age});

  factory Mahasiswa.fromJson(Map<String, dynamic> json) {
    return Mahasiswa(
      id: json['_id'],
      name: json['name'],
      age: json['age'],
    );
  }
}