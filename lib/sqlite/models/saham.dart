class Saham {
  final int tickerId;
  final String ticker;
  final int open;
  final int high;
  final int last;
  final double change;
  final int jumlah;

  Saham({
    required this.tickerId,
    required this.ticker,
    required this.open,
    required this.high,
    required this.last,
    required this.change,
    required this.jumlah,
  });

  Map<String, dynamic> toMap() {
    return {
      'tickerid': tickerId,
      'ticker': ticker,
      'open': open,
      'high': high,
      'last': last,
      'change': change,
      'jumlah': jumlah,
    };
  }

  factory Saham.fromMap(Map<String, dynamic> map) {
    return Saham(
      tickerId: map['tickerid'],
      ticker: map['ticker'],
      open: map['open'],
      high: map['high'],
      last: map['last'],
      change: map['change'],
      jumlah: map['jumlah'],
    );
  }
}
