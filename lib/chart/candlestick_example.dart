import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartSampleData {
  ChartSampleData({this.x, this.open, this.high, this.low, this.close});

  final DateTime? x;
  final double? open;
  final double? high;
  final double? low;
  final double? close;
}

class CandlestickExample extends StatelessWidget {
  CandlestickExample({super.key});

  late List<CandlestickSpot> chartData = [
    ChartSampleData(
        x: DateTime(2016, 01, 11),
        open: 98.97,
        high: 101.19,
        low: 95.36,
        close: 97.13),
    ChartSampleData(
        x: DateTime(2016, 01, 18),
        open: 98.41,
        high: 101.46,
        low: 93.42,
        close: 101.42),
    ChartSampleData(
        x: DateTime(2016, 01, 25),
        open: 101.52,
        high: 101.53,
        low: 92.39,
        close: 97.34),
    ChartSampleData(
        x: DateTime(2016, 02, 01),
        open: 96.47,
        high: 97.33,
        low: 93.69,
        close: 94.02),
    ChartSampleData(
        x: DateTime(2016, 02, 08),
        open: 93.13,
        high: 96.35,
        low: 92.59,
        close: 93.99),
    ChartSampleData(
        x: DateTime(2016, 02, 15),
        open: 95.02,
        high: 98.89,
        low: 94.61,
        close: 96.04),
    ChartSampleData(
        x: DateTime(2016, 02, 22),
        open: 96.31,
        high: 98.0237,
        low: 93.32,
        close: 96.91),
    ChartSampleData(
        x: DateTime(2016, 02, 29),
        open: 96.86,
        high: 103.75,
        low: 96.65,
        close: 103.01),
    ChartSampleData(
        x: DateTime(2016, 03, 07),
        open: 102.39,
        high: 102.83,
        low: 100.15,
        close: 102.26),
    ChartSampleData(
        x: DateTime(2016, 03, 12),
        open: 106.5,
        high: 106.5,
        low: 110.5,
        close: 109.5),
  ].map(
          (data){
        return CandlestickSpot(
          x: data.x!.millisecondsSinceEpoch.toDouble(),
          open: data.open!,
          high: data.high!,
          low: data.low!,
          close: data.close!,
        );
      }
  ).toList();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contoh Candlestick Chart"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CandlestickChart(
          CandlestickChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(show: true),
            borderData: FlBorderData(show: true),
            candlestickSpots: chartData,
          ),
        ),
      ),
    );
  }
}