import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ppbl/sqlite/connection.dart';
import 'models/saham.dart';

class FormTransaksi extends StatefulWidget {
  const FormTransaksi({super.key});

  @override
  State<FormTransaksi> createState() => _FormTransaksiState();
}

class _FormTransaksiState extends State<FormTransaksi> {
  final _formKey = GlobalKey<FormState>();
  final _jumlahController = TextEditingController();

  List<Saham> _daftarSaham = [];
  Saham? _selectedSaham;
  String _jenisTransaksi = 'Beli';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSaham();
  }

  @override
  void dispose() {
    _jumlahController.dispose();
    super.dispose();
  }

  Future<void> _loadSaham() async {
    final db = await openMyDatabase();
    final maps = await db.query('saham');

    setState(() {
      _daftarSaham = List.generate(maps.length, (i) {
        return Saham.fromMap(maps[i]);
      });

      if (_daftarSaham.isNotEmpty) {
        _selectedSaham = _daftarSaham.first;
      }
    });
  }

  Future<void> _submitTransaksi() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedSaham == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih saham terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final jumlah = int.parse(_jumlahController.text);
      final jenisTransaksiInt = _jenisTransaksi == 'Beli' ? 0 : 1;

      final db = await openMyDatabase();

      await db.transaction((txn) async {
        if (jenisTransaksiInt != 0 && jenisTransaksiInt != 1) {
          throw Exception('Jenis transaksi harus Beli atau Jual');
        }

        final sahamList = await txn.query(
          'saham',
          where: 'tickerid = ?',
          whereArgs: [_selectedSaham!.tickerId],
        );

        if (sahamList.isEmpty) {
          throw Exception('Saham tidak ditemukan');
        }

        final saham = sahamList.first;
        final jumlahSaatIni = saham['jumlah'] as int;

        int jumlahBaru;
        if (jenisTransaksiInt == 0) {
          jumlahBaru = jumlahSaatIni + jumlah;
        } else {
          if (jumlahSaatIni < jumlah) {
            throw Exception(
              'Stok tidak mencukupi. Stok tersedia: $jumlahSaatIni',
            );
          }
          jumlahBaru = jumlahSaatIni - jumlah;
        }

        await txn.insert('transaksi', {
          'tickerid': _selectedSaham!.tickerId,
          'jumlah_transaksi': jumlah,
          'jenis_transaksi': jenisTransaksiInt,
        });

        await txn.update(
          'saham',
          {'jumlah': jumlahBaru},
          where: 'tickerid = ?',
          whereArgs: [_selectedSaham!.tickerId],
        );
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Transaksi $_jenisTransaksi ${_selectedSaham!.ticker} sebanyak $jumlah lot berhasil',
            ),
            backgroundColor: Colors.green,
          ),
        );

        _jumlahController.clear();
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transaksi gagal: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Transaksi Saham')),
      body:
          _daftarSaham.isEmpty
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Memuat data saham...'),
                  ],
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pilih Saham',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              DropdownButton<Saham>(
                                value: _selectedSaham,
                                isExpanded: true,
                                items:
                                    _daftarSaham.map((saham) {
                                      return DropdownMenuItem<Saham>(
                                        value: saham,
                                        child: Text(
                                          '${saham.ticker} (Stok: ${saham.jumlah})',
                                        ),
                                      );
                                    }).toList(),
                                onChanged: (Saham? newValue) {
                                  setState(() {
                                    _selectedSaham = newValue;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Jenis Transaksi',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              DropdownButton<String>(
                                value: _jenisTransaksi,
                                isExpanded: true,
                                items:
                                    ['Beli', 'Jual'].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Row(
                                          children: [
                                            Icon(
                                              value == 'Beli'
                                                  ? Icons.arrow_upward
                                                  : Icons.arrow_downward,
                                              color:
                                                  value == 'Beli'
                                                      ? Colors.green
                                                      : Colors.red,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(value),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _jenisTransaksi = newValue!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Jumlah Lot',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _jumlahController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: const InputDecoration(
                                  hintText: 'Masukkan jumlah lot',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.numbers),
                                  suffixText: 'lot',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Jumlah lot tidak boleh kosong';
                                  }
                                  final jumlah = int.tryParse(value);
                                  if (jumlah == null || jumlah <= 0) {
                                    return 'Jumlah lot harus lebih dari 0';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      ElevatedButton(
                        onPressed: _isLoading ? null : _submitTransaksi,

                        child:
                            _isLoading
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text(
                                  '$_jenisTransaksi Saham',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
