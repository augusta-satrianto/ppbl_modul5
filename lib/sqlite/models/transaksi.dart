// ========== TRANSAKSI MODEL ==========
class Transaksi {
  final int? transaksiId;
  final int tickerId;
  final int jumlahTransaksi;
  final int jenisTransaksi; // 0 = beli, 1 = jual

  Transaksi({
    this.transaksiId,
    required this.tickerId,
    required this.jumlahTransaksi,
    required this.jenisTransaksi,
  }) {
    // Validasi jenis transaksi
    if (jenisTransaksi != 0 && jenisTransaksi != 1) {
      throw ArgumentError('Jenis transaksi harus 0 (beli) atau 1 (jual)');
    }
  }

  // Convert Transaksi object to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'transaksiid': transaksiId,
      'tickerid': tickerId,
      'jumlah_transaksi': jumlahTransaksi,
      'jenis_transaksi': jenisTransaksi,
    };
  }

  // Convert Map from database to Transaksi object
  factory Transaksi.fromMap(Map<String, dynamic> map) {
    return Transaksi(
      transaksiId: map['transaksiid'] as int?,
      tickerId: map['tickerid'] as int,
      jumlahTransaksi: map['jumlah_transaksi'] as int,
      jenisTransaksi: map['jenis_transaksi'] as int,
    );
  }

  // Get jenis transaksi as readable string
  String get jenisTransaksiString {
    return jenisTransaksi == 0 ? 'Beli' : 'Jual';
  }

  // Check if this is a buy transaction
  bool get isBeli => jenisTransaksi == 0;

  // Check if this is a sell transaction
  bool get isJual => jenisTransaksi == 1;

  // Create a copy of Transaksi with modified fields
  Transaksi copyWith({
    int? transaksiId,
    int? tickerId,
    int? jumlahTransaksi,
    int? jenisTransaksi,
  }) {
    return Transaksi(
      transaksiId: transaksiId ?? this.transaksiId,
      tickerId: tickerId ?? this.tickerId,
      jumlahTransaksi: jumlahTransaksi ?? this.jumlahTransaksi,
      jenisTransaksi: jenisTransaksi ?? this.jenisTransaksi,
    );
  }

  @override
  String toString() {
    return 'Transaksi{transaksiId: $transaksiId, tickerId: $tickerId, jumlahTransaksi: $jumlahTransaksi, jenisTransaksi: $jenisTransaksiString}';
  }
}

// ========== TRANSAKSI DETAIL MODEL ==========
// Model untuk menampilkan transaksi dengan detail saham (hasil JOIN)
class TransaksiDetail {
  final int transaksiId;
  final int tickerId;
  final String ticker;
  final int jumlahTransaksi;
  final int jenisTransaksi;

  TransaksiDetail({
    required this.transaksiId,
    required this.tickerId,
    required this.ticker,
    required this.jumlahTransaksi,
    required this.jenisTransaksi,
  });

  // Convert Map from database to TransaksiDetail object
  factory TransaksiDetail.fromMap(Map<String, dynamic> map) {
    return TransaksiDetail(
      transaksiId: map['transaksiid'] as int,
      tickerId: map['tickerid'] as int,
      ticker: map['ticker'] as String,
      jumlahTransaksi: map['jumlah_transaksi'] as int,
      jenisTransaksi: map['jenis_transaksi'] as int,
    );
  }

  // Get jenis transaksi as readable string
  String get jenisTransaksiString {
    return jenisTransaksi == 0 ? 'Beli' : 'Jual';
  }

  // Check if this is a buy transaction
  bool get isBeli => jenisTransaksi == 0;

  // Check if this is a sell transaction
  bool get isJual => jenisTransaksi == 1;

  @override
  String toString() {
    return 'TransaksiDetail{transaksiId: $transaksiId, tickerId: $tickerId, ticker: $ticker, jumlahTransaksi: $jumlahTransaksi, jenisTransaksi: $jenisTransaksiString}';
  }
}
