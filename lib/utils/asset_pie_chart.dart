import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kryptonia/helpers/colors.dart';
import 'package:kryptonia/helpers/strings.dart';
import 'indicator.dart';

class AssetPieChart extends StatefulWidget {
  const AssetPieChart({
    Key? key,
    this.balances,
  }) : super(key: key);

  final Map<dynamic, dynamic>? balances;
  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<AssetPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(
          height: 18,
        ),
        Expanded(
          child: AspectRatio(
            aspectRatio: 1.5,
            child: PieChart(
              PieChartData(
                  pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  }),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: widget.balances!.isNotEmpty ? 8 : 4,
                  centerSpaceRadius: 60,
                  sections: showingSections(widget.balances)),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: indicators((widget.balances)),
        ),
        const SizedBox(
          width: 28,
        ),
      ],
    );
  }

  List<Widget> indicators(Map<dynamic, dynamic>? balances) {
    if (balances!.isNotEmpty) {
      var allBalances = balances.values;
      double sumBal = allBalances.reduce((sum, element) => sum + element);

      return List.generate(CRYPTOCURRENCIES.length, (i) {
        double val =
            sumBal != 0.0 ? (((balances[UNITS[i]] / sumBal)) * 100) : 0.0;

        return indicatorList('${val.toStringAsFixed(2)}%', i);
      });
    } else {
      return List.generate(CRYPTOCURRENCIES.length, (i) {
        return indicatorList('0.0', i);
      });
    }
  }

  Indicator indicatorList(String value, int i) {
    return Indicator(
      color: PIECHARTCOLORS[i],
      text: UNITS[i],
      value: value,
      isSquare: false,
      size: 12,
    );
  }

  List<PieChartSectionData> showingSections(Map<dynamic, dynamic>? balances) {
    if (balances!.isNotEmpty) {
      var allBalances = balances.values;
      double sumBal = allBalances.reduce((sum, element) => sum + element);

      return List.generate(CRYPTOCURRENCIES.length, (i) {
        final isTouched = i == touchedIndex;
        final fontSize = isTouched ? 16.0 : 12.0;
        final radius = isTouched ? 25.0 : 15.0;
        double val = ((balances[UNITS[i]] / sumBal)) * 100;
        if (sumBal == 0.0) {
          return pieChartSectionData(100.00, '', i, 12.0, 15.0);
        } else
          return pieChartSectionData(
              val,
              isTouched ? '${val.toStringAsFixed(2)}%' : "",
              i,
              fontSize,
              radius);
      });
    } else {
      return List.generate(CRYPTOCURRENCIES.length, (i) {
        return pieChartSectionData(100.00, '', i, 12.0, 15.0);
      });
    }
  }

  PieChartSectionData pieChartSectionData(
      double val, title, int i, fontSize, radius) {
    return PieChartSectionData(
      color: PIECHARTCOLORS[i],
      value: val,
      title: title,
      radius: radius,
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: white,
      ),
    );
  }
}
