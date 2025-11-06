import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyAreaChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contoh Area Chart"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LineChart(
            LineChartData(

              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(0, 4),
                    FlSpot(1, 5),
                    FlSpot(2, 4),
                    FlSpot(3, 6),

                  ],
                  isCurved: false, // For smoother curves
                  barWidth: 2,
                  belowBarData: BarAreaData( // For the area fill
                    show: true,
                    color: Colors.blue, // Shading color

                  ),
                ),
                LineChartBarData(
                  spots: [
                    FlSpot(0, 3),
                    FlSpot(1, 3),
                    FlSpot(2, 3),
                    FlSpot(3, 9),

                  ],
                  isCurved: false, // For smoother curves
                  barWidth: 2,
                  belowBarData: BarAreaData( // For the area fill
                    show: true,
                    color: Colors.greenAccent, // Shading color

                  ),
                ),
              ],

            ),
          ),
        ),
      ),
    );

  }
}