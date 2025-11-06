import 'package:flutter/material.dart';
import 'package:ppbl/sqlite/connection.dart';
import 'package:ppbl/sqlite/read_data.dart';

class FormInput extends StatefulWidget {
  const FormInput({super.key});

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  final tickerController = TextEditingController();
  final openController = TextEditingController();
  final highController = TextEditingController();
  final lastController = TextEditingController();
  final changeController = TextEditingController();
  final jumlahController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Input Saham")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            buildInput("Ticker", tickerController),
            buildInput("Open", openController, isNumber: true),
            buildInput("High", highController, isNumber: true),
            buildInput("Last", lastController, isNumber: true),
            buildInput("Change", changeController, isNumber: true),
            buildInput("Jumlah", jumlahController, isNumber: true),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () async {
                final db = await openMyDatabase();

                await db.insert("saham", {
                  "ticker": tickerController.text,
                  "open": int.tryParse(openController.text),
                  "high": int.tryParse(highController.text),
                  "last": int.tryParse(lastController.text),
                  "change": double.tryParse(changeController.text),
                  "jumlah": int.tryParse(jumlahController.text),
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Data saham berhasil disimpan")),
                );

                tickerController.clear();
                openController.clear();
                highController.clear();
                lastController.clear();
                changeController.clear();
              },
              child: const Text("Simpan Data Saham"),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReadData()),
                );
              },
              child: const Text("Lihat Data"),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () async {
                try {
                  await insertDefaultSahamData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Data saham berhasil dimasukkan'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Terjadi kesalahan: $e')),
                  );
                }
              },
              child: const Text("Isi Data Saham"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInput(
    String label,
    TextEditingController c, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
}

Future<void> insertDefaultSahamData() async {
  final db = await openMyDatabase();

  final List<Map<String, dynamic>> dataSaham = [
    {
      'ticker': 'TLKM',
      'open': 3380,
      'high': 3500,
      'last': 3490,
      'change': 2.05,
      'jumlah': 10,
    },
    {
      'ticker': 'AMMN',
      'open': 6750,
      'high': 6750,
      'last': 6500,
      'change': -3.7,
      'jumlah': 10,
    },
    {
      'ticker': 'BREN',
      'open': 4500,
      'high': 4610,
      'last': 4580,
      'change': 1.78,
      'jumlah': 10,
    },
    {
      'ticker': 'CUAN',
      'open': 5200,
      'high': 5525,
      'last': 5400,
      'change': 3.85,
      'jumlah': 10,
    },
  ];

  for (var data in dataSaham) {
    await db.insert('saham', data);
  }
}
