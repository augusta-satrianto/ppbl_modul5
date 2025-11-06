import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChartExample extends StatelessWidget{

  const BarChartExample({super.key});

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contoh Chart"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            barGroups: [
              BarChartGroupData(
                  x: 0,
                  barRods: [BarChartRodData(toY: 100, color: Colors.blueAccent),
                    BarChartRodData(toY: 110, color: Colors.black),
                    BarChartRodData(toY: 120, color: Colors.red)
                  ]
              ),
              BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(toY: 300, color: Colors.blueAccent),
                    BarChartRodData(toY: 250, color: Colors.black),
                    BarChartRodData(toY: 270, color: Colors.red)
                  ]
              ),
              BarChartGroupData(
                  x: 2,
                  barRods: [
                    BarChartRodData(toY: 100, color: Colors.blueAccent),
                    BarChartRodData(toY: 50, color: Colors.black),
                    BarChartRodData(toY: 125, color: Colors.red)
                  ]
              ),
              BarChartGroupData(
                  x: 3,
                  barRods: [
                    BarChartRodData(toY: 400, color: Colors.blueAccent),
                    BarChartRodData(toY: 450, color: Colors.black),
                    BarChartRodData(toY: 525, color: Colors.red)
                  ]
              ),
            ],
          ),
        ),
      ),
    );
  }
}

