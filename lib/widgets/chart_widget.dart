import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartWidget extends StatelessWidget {
  final List<double> data;

  const ChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 2,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.1),
            ),
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}