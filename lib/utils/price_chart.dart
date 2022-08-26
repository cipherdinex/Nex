import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kryptonia/helpers/strings.dart';

class PriceChart extends StatelessWidget {
  PriceChart({
    required this.sparkline,
    required this.color,
  });

  final List? sparkline;
  final Color color;
  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = [];
    if (sparkline != null) {
      for (int i = 0; i < sparkline!.length; i++) {
        FlSpot newSpot = FlSpot(i.toDouble(), sparkline![i]);
        spots.add(newSpot);
      }
    } else {
      spots = [];
    }

    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(enabled: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots.isEmpty ? defaultSpark : spots,
            isCurved: true,
            barWidth: 2,
            colors: [
              color,
            ],
            dotData: FlDotData(
              show: false,
            ),
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: false,
          ),
          leftTitles: SideTitles(
            showTitles: false,
          ),
          topTitles: SideTitles(showTitles: false),
          rightTitles: SideTitles(showTitles: false),
        ),
        gridData: FlGridData(
          show: false,
          drawVerticalLine: false,
          horizontalInterval: 1,
        ),
      ),
    );
  }
}
