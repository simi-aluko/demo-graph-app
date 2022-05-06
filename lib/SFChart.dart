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

import 'dart:async';
import 'dart:developer';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartApp extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  int valve;
  ChartApp(this.valve, {Key? key}) : super(key: key);

  @override
  ChartAppState createState() => ChartAppState();
}

class ChartAppState extends State<ChartApp>
    with AutomaticKeepAliveClientMixin<ChartApp> {
  List<TimeSeries> fullFlowData = <TimeSeries>[];
  List<TimeSeries> flowData = <TimeSeries>[];
  ChartSeriesController? flowSeriesController;

  List<TimeSeries> fullPressureData = <TimeSeries>[];
  List<TimeSeries> pressureData = <TimeSeries>[];
  ChartSeriesController? pressureSeriesController;

  Timer? timer;
  int startIndex = 0;
  int endIndex = 19;

  late ZoomPanBehavior _zoomPanBehavior;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: loadAsset(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return SfCartesianChart(
            title: ChartTitle(text: "Valve ${widget.valve + 1}"),
            enableAxisAnimation: true,
            backgroundColor: Colors.white,
            legend: Legend(isVisible: true, position: LegendPosition.top),
            zoomPanBehavior: _zoomPanBehavior,
            //Specifying date time interval type as hours
            primaryXAxis: DateTimeAxis(
                title: AxisTitle(
                    text: "Time (Hour:min:sec)",
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
                majorGridLines: MajorGridLines(width: 0),
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                intervalType: DateTimeIntervalType.seconds,
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
            primaryYAxis: NumericAxis(
                decimalPlaces: 1,
                title: AxisTitle(
                    text: "Flow and Pressure",
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: 12))),
            series: <ChartSeries<TimeSeries, DateTime>>[
              LineSeries<TimeSeries, DateTime>(
                  dataSource: flowData,
                  xValueMapper: (TimeSeries sales, _) => sales.time,
                  yValueMapper: (TimeSeries sales, _) => sales.parameter,
                  name: 'Flow',
                  onRendererCreated: (ChartSeriesController controller) {
                    flowSeriesController = controller;
                  },
                  animationDuration: 1000),
              LineSeries<TimeSeries, DateTime>(
                  dataSource: pressureData,
                  xValueMapper: (TimeSeries sales, _) => sales.time,
                  yValueMapper: (TimeSeries sales, _) => sales.parameter,
                  name: 'Pressure',
                  onRendererCreated: (ChartSeriesController controller) {
                    pressureSeriesController = controller;
                  },
                  animationDuration: 1000),
            ]);
      },
    );
  }

  loadAsset() async {
    final myData = await rootBundle.loadString('assets/test_data.csv');
    List<List<dynamic>> rowsAsListOfValues =
        const CsvToListConverter().convert(myData);

    for (int i = 0; i < rowsAsListOfValues.length; i++) {
      if (i == 0) continue;

      String dateString = rowsAsListOfValues[i][1];
      DateTime date = DateFormat('dd/MM/yyyy H:m:s').parse(dateString);

      switch (widget.valve) {
        case 0:
          {
            fullFlowData.add(TimeSeries(date, rowsAsListOfValues[i][6]));
            fullPressureData.add(TimeSeries(date, rowsAsListOfValues[i][7]));
          }
          break;
        case 1:
          {
            fullFlowData.add(TimeSeries(date, rowsAsListOfValues[i][13]));
            fullPressureData.add(TimeSeries(date, rowsAsListOfValues[i][14]));
          }
          break;
        case 2:
          {
            fullFlowData.add(TimeSeries(date, rowsAsListOfValues[i][20]));
            fullPressureData.add(TimeSeries(date, rowsAsListOfValues[i][21]));
          }
          break;
      }

      if (i <= endIndex + 1) {
        flowData.add(fullFlowData[i - 1]);
        pressureData.add(fullPressureData[i - 1]);
      }
    }

    timer =
        Timer.periodic(const Duration(milliseconds: 500), _updateDataSource);
  }

  void _updateDataSource(Timer timer) {
    startIndex += 1;
    endIndex += 1;

    flowData.add(fullFlowData[endIndex]);
    if (flowData.length == 21) {
      flowData.removeAt(0);
      flowSeriesController!.updateDataSource(
        addedDataIndexes: <int>[flowData.length - 1],
        removedDataIndexes: <int>[0],
      );
    }

    pressureData.add(fullPressureData[endIndex]);
    if (pressureData.length == 21) {
      pressureData.removeAt(0);
      pressureSeriesController!.updateDataSource(
        addedDataIndexes: <int>[pressureData.length - 1],
        removedDataIndexes: <int>[0],
      );
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
        // Enables pinch zooming
        enablePinching: true,
        enablePanning: true,
        enableSelectionZooming: true);
    super.initState();
  }
}

class TimeSeries {
  TimeSeries(this.time, this.parameter);

  final DateTime time;
  final double parameter;
}
