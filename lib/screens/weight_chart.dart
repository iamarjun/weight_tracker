import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/dateUtil.dart';
import 'package:weight_tracker/models/weight_record.dart';

class WeightChart extends StatefulWidget {
  @override
  _WeightChartState createState() => _WeightChartState();
}

class _WeightChartState extends State<WeightChart> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  List<String> weights = [
    '0 Kg',
    '10 Kg',
    '20 Kg',
    '30 Kg',
    '40 Kg',
    '50 Kg',
    '60 Kg',
    '70 Kg',
    '80 Kg',
    '90 Kg',
    '100 Kg',
    '110 Kg',
    '120 Kg',
    '130 Kg'
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    final records = Provider.of<List<WeightRecord>>(context);
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              showAvg = !showAvg;
            });
          },
          child: Text(
            'Average',
            style: TextStyle(
                fontSize: 12,
                color: !showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
          ),
        ),
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
                color: Color(0xff232d37)),
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 18.0, left: 12.0, top: 24, bottom: 12),
              child: LineChart(
                showAvg ? avgData(records) : mainData(records),
              ),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData(List<WeightRecord> records) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          getTitles: (value) {
            print(records[value.toInt()].date);
            return DateUtil.getDay(records[value.toInt()].date);
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          getTitles: (value) {
            return value > 0.0 ? weights[value.toInt() - 1] : '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: records.length.toDouble() - 1,
      minY: 0,
      maxY: weights.length.toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: records
              .asMap()
              .entries
              .map((e) => FlSpot(e.key.toDouble(), e.value.wgt / 10))
              .toList(),
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  LineChartData avgData(List<WeightRecord> records) {
    double avgWeight = 0.0;
    records.forEach((element) => avgWeight += element.wgt);
    avgWeight = (avgWeight / records.length);
    print('Average weight $avgWeight');

    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 12),
          getTitles: (value) {
            print(value);
            return DateUtil.getDay(records[value.toInt()].date);
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          getTitles: (value) {
            return value > 0.0 ? weights[value.toInt() - 1] : '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: records.length.toDouble() - 1,
      minY: 0,
      maxY: weights.length.toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: records
              .asMap()
              .entries
              .map((e) => FlSpot(e.key.toDouble(), avgWeight / 10))
              .toList(),
          isCurved: true,
          colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2),
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2),
          ],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(show: true, colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)
                .withOpacity(0.1),
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)
                .withOpacity(0.1),
          ]),
        ),
      ],
    );
  }
}
