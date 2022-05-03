/*
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SfChart extends StatefulWidget {
  const SfChart({Key? key}) : super(key: key);

  @override
  State<SfChart> createState() => _SfChartState();
}

class _SfChartState extends State<SfChart> {

  var flowData = <TimeSeries>[];
  var pressureData = <TimeSeries>[];

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: DateTimeAxis(
            intervalType: DateTimeIntervalType.minutes
        ),
        series: <ChartSeries<TimeSeries, DateTime>>[
          LineSeries<TimeSeries, DateTime>(
              dataSource: flowData,
              xValueMapper: (TimeSeries sales, _) => sales.time,
              yValueMapper: (TimeSeries sales, _) => sales.parameter
          )
        ]
    );
  }

  loadAsset() async{
    final myData = await  rootBundle.loadString('assets/test_data.csv');
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(myData);
    var data1 = <TimeSeries>[];
    var data2 = <TimeSeries>[];

    for (int i = 0; i < rowsAsListOfValues.length; i++){
      if(i == 0) continue;

      String dateString = rowsAsListOfValues[i][1];
      DateTime date = DateFormat('dd/MM/yyyy H:m:s').parse(dateString);
      // GraphDataClass channel0 = GraphDataClass(rowsAsListOfValues[i][1], rowsAsListOfValues[i][6], rowsAsListOfValues[i][7]);
      // GraphDataClass channel1 = GraphDataClass(rowsAsListOfValues[i][1], rowsAsListOfValues[i][13], rowsAsListOfValues[i][14]);
      // GraphDataClass channel2 = GraphDataClass(rowsAsListOfValues[i][1], rowsAsListOfValues[i][20], rowsAsListOfValues[i][21]);
      data1.add(TimeSeries(date, rowsAsListOfValues[i][6]));
      data2.add(TimeSeries(date, rowsAsListOfValues[i][7]));
    }

    setState(() {
      flowData = data1;
      pressureData = data2;
    });
  }

  void setChartData() {

  }
}

class TimeSeries {
  final DateTime time;
  final double parameter;

  TimeSeries(this.time, this.parameter);
}
*/

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartApp extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ChartApp({Key? key}) : super(key: key);

  @override
  ChartAppState createState() => ChartAppState();
}

class ChartAppState extends State<ChartApp> {
  List<TimeSeries> pressureData = <TimeSeries>[];
  List<TimeSeries> flowData = <TimeSeries>[];

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        backgroundColor: Colors.white,
        //Specifying date time interval type as hours
        primaryXAxis: DateTimeAxis(
            majorGridLines: MajorGridLines(width: 0),
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            intervalType: DateTimeIntervalType.seconds,
            interval: 8,
            labelRotation: 120,
            axisLabelFormatter: (AxisLabelRenderDetails args) {
              late String text;
              text = DateTime.fromMillisecondsSinceEpoch(args.value.toInt())
                      .hour
                      .toString() +
                  ':' +
                  DateTime.fromMillisecondsSinceEpoch(args.value.toInt())
                      .minute
                      .toString() +
                  ':' +
                  DateTime.fromMillisecondsSinceEpoch(args.value.toInt())
                      .second
                      .toString();
              return ChartAxisLabel(text, args.textStyle);
            }),
        series: <ChartSeries<TimeSeries, DateTime>>[
          LineSeries<TimeSeries, DateTime>(
            dataSource: flowData,
            xValueMapper: (TimeSeries sales, _) => sales.time,
            yValueMapper: (TimeSeries sales, _) => sales.parameter,
            name: 'Sales',
          ),
          LineSeries<TimeSeries, DateTime>(
            dataSource: pressureData,
            xValueMapper: (TimeSeries sales, _) => sales.time,
            yValueMapper: (TimeSeries sales, _) => sales.parameter,
            name: 'Sales',
          ),
        ]);
  }

  loadAsset() async {
    final myData = await rootBundle.loadString('assets/test_data.csv');
    List<List<dynamic>> rowsAsListOfValues =
        const CsvToListConverter().convert(myData);
    var data1 = <TimeSeries>[];
    var data2 = <TimeSeries>[];

    for (int i = 0; i < 20 /*rowsAsListOfValues.length*/; i++) {
      if (i == 0) continue;

      String dateString = rowsAsListOfValues[i][1];
      DateTime date = DateFormat('dd/MM/yyyy H:m:s').parse(dateString);
      // GraphDataClass channel0 = GraphDataClass(rowsAsListOfValues[i][1], rowsAsListOfValues[i][6], rowsAsListOfValues[i][7]);
      // GraphDataClass channel1 = GraphDataClass(rowsAsListOfValues[i][1], rowsAsListOfValues[i][13], rowsAsListOfValues[i][14]);
      // GraphDataClass channel2 = GraphDataClass(rowsAsListOfValues[i][1], rowsAsListOfValues[i][20], rowsAsListOfValues[i][21]);
      data1.add(TimeSeries(date, rowsAsListOfValues[i][6]));
      data2.add(TimeSeries(date, rowsAsListOfValues[i][7]));
    }

    setState(() {
      flowData = data1;
      pressureData = data2;
    });
  }

  @override
  void initState() {
    super.initState();
    loadAsset();
  }
}

class ChartSampleData {
  ChartSampleData({this.x, this.yValue});

  final DateTime? x;
  final double? yValue;
}

class TimeSeries {
  TimeSeries(this.time, this.parameter);

  final DateTime time;
  final double parameter;
}
