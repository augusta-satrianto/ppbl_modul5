import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartExample extends StatelessWidget{
  const ChartExample({super.key});

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contoh Chart"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 1),
                  FlSpot(1, 3),
                  FlSpot(2, 2),
                  FlSpot(3, 5),
                  FlSpot(4, 3),
                  FlSpot(5, 4),
                ],
                isCurved: false,
                barWidth: 1,
                color: Colors.red,

              ),
            ],

          ),

        ),
      ),
    );
  }
}

