import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

ScatterChartData sampleScatterData() {
  return ScatterChartData(
    scatterSpots: [
      ScatterSpot(4,1,renderPriority: 4),
      ScatterSpot(3, 4),
      ScatterSpot(2, 5),
      ScatterSpot(4, 7),
      ScatterSpot(6, 3),
      ScatterSpot(8, 6),
    ],
    minX: 0,
    maxX: 10,
    minY: 0,
    maxY: 10,
    // You can customize grid data, titles, and other aspects here
    gridData: FlGridData(show: true),
    titlesData: FlTitlesData(
      show: true,
      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    ),
    scatterTouchData: ScatterTouchData(
      touchTooltipData: ScatterTouchTooltipData(
        getTooltipItems: (ScatterSpot touchedSpot) {
          return ScatterTooltipItem(
            'X: ${touchedSpot.x.toStringAsFixed(1)}\nY: ${touchedSpot.y.toStringAsFixed(1)}',
            textStyle: const TextStyle(color: Colors.white),
          );
        },
      ),
    ),
  );
}

class ScatterChartExample extends StatelessWidget{
  const ScatterChartExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contoh Scatter Chart"),
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: ScatterChart(
            sampleScatterData(),
          ),
        ),
      ),
    );
  }
}