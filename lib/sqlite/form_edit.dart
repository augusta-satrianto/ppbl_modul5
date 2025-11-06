import 'package:flutter/material.dart';
import 'package:ppbl/sqlite/connection.dart';

import 'models/saham.dart';

class FormEdit extends StatefulWidget {
  final Saham saham;
  const FormEdit({super.key, required this.saham});

  @override
  State<FormEdit> createState() => _FormEditState();
}

class _FormEditState extends State<FormEdit> {
  late TextEditingController tickerController;
  late TextEditingController openController;
  late TextEditingController highController;
  late TextEditingController lastController;
  late TextEditingController changeController;
  late TextEditingController jumlahController;

  @override
  void initState() {
    super.initState();
    tickerController = TextEditingController(text: widget.saham.ticker);
    openController = TextEditingController(text: widget.saham.open.toString());
    highController = TextEditingController(text: widget.saham.high.toString());
    lastController = TextEditingController(text: widget.saham.last.toString());
    changeController = TextEditingController(
      text: widget.saham.change.toString(),
    );
    jumlahController = TextEditingController(
      text: widget.saham.jumlah.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Saham")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            buildInput("Ticker", tickerController),
            buildInput("Open", openController, isNumber: true),
            buildInput("High", highController, isNumber: true),
            buildInput("Last", lastController, isNumber: true),
            buildInput("Change", changeController, isNumber: true),
            buildInput("Jumlah", jumlahController, isNumber: true),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                final db = await openMyDatabase();
                await db.update(
                  "saham",
                  {
                    "ticker": tickerController.text,
                    "open": int.tryParse(openController.text),
                    "high": int.tryParse(highController.text),
                    "last": int.tryParse(lastController.text),
                    "change": double.tryParse(changeController.text),
                    "jumlah": int.tryParse(jumlahController.text),
                  },
                  where: "tickerid = ?",
                  whereArgs: [widget.saham.tickerId],
                );

                Navigator.pop(context);
              },
              child: const Text("Update Saham"),
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
