import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('username', 'Patrick');
  await prefs.setInt('age', 32);
  await prefs.setDouble('height', 5.5);
  await prefs.setBool('isDarkMode', true);
  await prefs.setStringList('hobbies', ['Reading', 'Gaming', 'Coding']);
}

Future<String?> getUsername() async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? username      = prefs.getString('username');

  return username;
}

Future<void> removeData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('username');
}

Future<void> clearData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

Future<void> readData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  String? username      = prefs.getString('username');
  int? age              = prefs.getInt('age');
  double? height        = prefs.getDouble('height');
  bool? isDarkMode      = prefs.getBool('isDarkMode');
  List<String>? hobbies = prefs.getStringList('hobbies');

  print('Username: $username');
  print('Age: $age');
  print('Height: $height');
  print('Dark Mode: $isDarkMode');
  print('Hobbies: $hobbies');
}

class SharedPreferenceHome extends StatefulWidget{
  const SharedPreferenceHome({super.key});

  @override
  State<SharedPreferenceHome> createState() => _SharedPreferenceHomeState();
}

class _SharedPreferenceHomeState extends State<SharedPreferenceHome>{

  TextEditingController txtUsername = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shared Preference"),
      ),
      body: Center(child:
        Column(
          children: [
            Text("data"),
            TextField(
              controller: txtUsername,
            ),
            TextButton(
                onPressed: () => saveData(),
                child: Text("Tambah data")
            ),
            TextButton(
                onPressed: () => readData(),
                child: Text("Baca data")
            ),
            TextButton(
                onPressed: () => clearData(),
                child: Text("Hapus data")
            ),
            TextButton(
                onPressed: () => getUsername().then(
                        (data) => {
                          txtUsername.text = data!
                        }
                ),
                child: Text("Ambil username data")
            ),
          ],
        )),
    );
  }
}