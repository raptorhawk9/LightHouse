import 'dart:collection';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';

/// A horizontal bar chart widget that dislays numbers, automatically sorting by key.
class NRGBarChart extends StatefulWidget {
  final String title;
  final String height;
  final String width;
  final SplayTreeMap<int, double> data;
  final List<int> removedData;

  const NRGBarChart(
      {super.key,
      required this.title,
      required this.height,
      required this.width,
      required this.data,
      required this.removedData});

  @override
  State<StatefulWidget> createState() => _NRGBarChartState();
}

class _NRGBarChartState extends State<NRGBarChart> {
  String get _title => widget.title;
  String get _height => widget.height;
  String get _width => widget.width;
  SplayTreeMap<int, double> get _data => widget.data;
  List<int> get _removedData => widget.removedData;

  /// Converts the [SplayTreeMap] dataset [_data] into a [BarChartGroupData] list to display.
  List<BarChartGroupData> getBarGroups() => _data.keys
      .map((int key) => BarChartGroupData(x: key, barRods: [
            BarChartRodData(
                toY: _data[key]!,
                gradient: LinearGradient(
                    colors: !_removedData.contains(key)
                        ? [Constants.pastelYellow, Constants.pastelRed]
                        : [Colors.grey, Colors.brown],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                width: (double.parse(_width) - 20) / _data.length * 0.6),
          ]))
      .toList();

  /// Returns the average of [_data] excluding specified data from [_removedData].
  double getAverageData() =>
      (sum(_data.values) - sum(_removedData.map((x) => _data[x]))) /
      (_data.length - _removedData.length);

  /// Returns the average of an [Iterable].
  double sum(Iterable l) => l.fold(0.0, (x, y) => x + y!);

  num roundAtPlace(double number, int place) =>
      num.parse(number.toStringAsFixed(place));

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.parse(_width),
      height: double.parse(_height),
      decoration: BoxDecoration(
          color: Constants.pastelWhite,
          borderRadius: BorderRadius.circular(Constants.borderRadius)),
      child: Column(
        children: [
          // Title Text.
          Text(_title,
              style: TextStyle(
                  fontFamily: "Comfortaa",
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: double.parse(_width) / 10)),
          // AspectRatio necessary to prevent BarChart from throwing a formatting error.
          AspectRatio(
            aspectRatio: 2,
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: BarChart(BarChartData(
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: AxisTitles(),
                    rightTitles: AxisTitles(),
                    leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return SideTitleWidget(
                            meta: meta,
                            space: 4,
                            child: Text('${value.toInt()}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: double.parse(_width) / 25)));
                      },
                    )),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return SideTitleWidget(
                            meta: meta,
                            space: 4,
                            child: Text('${value.toInt()}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: double.parse(_width) / 25)));
                      },
                    )),
                  ),
                  barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (group) =>
                            Color.fromARGB(200, 255, 255, 255),
                      )),
                  barGroups: getBarGroups(),
                  gridData: FlGridData(
                      drawVerticalLine: false,
                      horizontalInterval: 1,
                      getDrawingHorizontalLine: (x) =>
                          const FlLine(color: Colors.grey, strokeWidth: 1)))),
            )
          ),
          // Average value text.
          Text(
              "AVERAGE: ${roundAtPlace(getAverageData(), 2)}", // TODO Calculate average value
              style: TextStyle(
                  fontFamily: "Comfortaa",
                  color: Colors.black,
                  fontSize: double.parse(_width) / 20))
        ],
      ),
    );
  }
}