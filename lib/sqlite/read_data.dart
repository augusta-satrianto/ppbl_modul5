import 'package:flutter/material.dart';
import 'package:ppbl/sqlite/connection.dart';
import 'package:ppbl/sqlite/form_transaksi.dart';

import 'form_edit.dart';
import 'models/saham.dart';

Future<List<Saham>> fetchSaham() async {
  final db = await openMyDatabase();

  final maps = await db.query('saham');

  return List.generate(maps.length, (i) {
    return Saham.fromMap(maps[i]);
  });
}

class ReadData extends StatefulWidget {
  const ReadData({super.key});

  @override
  State<ReadData> createState() => _ReadDataState();
}

class _ReadDataState extends State<ReadData> {
  List<Saham> futureSaham = [];

  Future<void> _deleteSaham(Saham saham) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Konfirmasi Hapus'),
            content: Text(
              'Apakah Anda yakin ingin menghapus saham ${saham.ticker}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Hapus'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        final db = await openMyDatabase();

        await db.transaction((txn) async {
          await txn.delete(
            'transaksi',
            where: 'tickerid = ?',
            whereArgs: [saham.tickerId],
          );

          await txn.delete(
            'saham',
            where: 'tickerid = ?',
            whereArgs: [saham.tickerId],
          );
        });

        setState(() {});

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${saham.ticker} berhasil dihapus"),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Gagal menghapus: $e"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Saham")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FormTransaksi(),
                    ),
                  );
                },
                child: const Text("Transaksi"),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: FutureBuilder(
                  future: fetchSaham(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasData) {
                      futureSaham = snapshot.data!;
                    } else {
                      return const Center(child: Text("Tidak ada data"));
                    }

                    if (futureSaham.isEmpty) {
                      return const Center(child: Text("Tidak ada data saham"));
                    }

                    return ListView.builder(
                      itemCount: futureSaham.length,
                      itemBuilder: (context, index) {
                        final saham = futureSaham[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        saham.ticker,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text("Open : ${saham.open}"),
                                      Text("High : ${saham.high}"),
                                      Text("Last : ${saham.last}"),
                                      Text(
                                        "Change : ${saham.change}%",
                                        style: TextStyle(
                                          color:
                                              (saham.change) < 0
                                                  ? Colors.red
                                                  : Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text("Jumlah : ${saham.jumlah}"),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    FormEdit(saham: saham),
                                          ),
                                        ).then((value) {
                                          setState(() {});
                                        });
                                      },
                                      tooltip: 'Edit',
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => _deleteSaham(saham),
                                      tooltip: 'Hapus',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
