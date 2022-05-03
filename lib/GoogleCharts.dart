// Copyright 2018 the Charts project authors. Please see the AUTHORS file
// for details.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// Timeseries chart example
// EXCLUDE_FROM_GALLERY_DOCS_START
import 'dart:math';
// EXCLUDE_FROM_GALLERY_DOCS_END
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SimpleTimeSeriesChart extends StatefulWidget {
  final bool animate;

  const SimpleTimeSeriesChart({Key? key, this.animate = true}) : super(key: key);

  @override
  State<SimpleTimeSeriesChart> createState() => _SimpleTimeSeriesChartState();

}

class _SimpleTimeSeriesChartState extends State<SimpleTimeSeriesChart> {
  final flowData = <TimeSeries>[];
  final pressureData = <TimeSeries>[];
  List<charts.Series<dynamic, DateTime>> seriesList = [];

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: widget.animate,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: const charts.BasicNumericTickProviderSpec(desiredMinTickCount: 8,),
        showAxisLine: true,),
      domainAxis: new charts.DateTimeAxisSpec(
        tickProviderSpec: charts.DayTickProviderSpec(increments: [1]),

        showAxisLine: false,
      ),
    );
  }

  loadAsset() async {
    final myData = await  rootBundle.loadString('assets/test_data.csv');
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(myData);

    for (int i = 0; i < rowsAsListOfValues.length; i++){
      if(i == 0) continue;

      String dateString = rowsAsListOfValues[i][1];
      DateTime date = DateFormat('dd/MM/yyyy H:m:ss').parse(dateString);
      // GraphDataClass channel0 = GraphDataClass(rowsAsListOfValues[i][1], rowsAsListOfValues[i][6], rowsAsListOfValues[i][7]);
      // GraphDataClass channel1 = GraphDataClass(rowsAsListOfValues[i][1], rowsAsListOfValues[i][13], rowsAsListOfValues[i][14]);
      // GraphDataClass channel2 = GraphDataClass(rowsAsListOfValues[i][1], rowsAsListOfValues[i][20], rowsAsListOfValues[i][21]);
      flowData.add(TimeSeries(date, rowsAsListOfValues[i][6]));
      pressureData.add(TimeSeries(date, rowsAsListOfValues[i][7]));

      setState(() {
        setChartData();
      });
    }
  }

  setChartData(){
    seriesList = [
      charts.Series<TimeSeries, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (TimeSeries sales, _) => sales.time,
        measureFn: (TimeSeries sales, _) => sales.parameter,
        data: flowData,
      ),
      charts.Series<TimeSeries, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeries sales, _) => sales.time,
        measureFn: (TimeSeries sales, _) => sales.parameter,
        data: pressureData,
      )
    ];
  }

  @override
  void initState() {
    super.initState();
    setChartData();
    loadAsset();
  }
}


class TimeSeries {
  final DateTime time;
  final double parameter;

  TimeSeries(this.time, this.parameter);
}
