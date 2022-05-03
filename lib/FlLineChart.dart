import 'package:csv/csv.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyLineChart extends StatefulWidget {

  MyLineChart({Key? key}) : super(key: key);

  @override
  State<MyLineChart> createState() => _MyLineChartState();
}

class _MyLineChartState extends State<MyLineChart> {
  LineChartData data = LineChartData();

  List<FlSpot> flspots = [];

  @override
  void initState(){
    setChartData();
    loadAsset();
  }

  loadAsset() async{
    final myData = await  rootBundle.loadString('assets/test_data.csv');
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(myData);
    // List<GraphDataClass> timeFlowPressure0 = [];
    // List<GraphDataClass> timeFlowPressure1 = [];
    // List<GraphDataClass> timeFlowPressure2 = [];

    for (int i = 0; i < rowsAsListOfValues.length; i++){
      if(i == 0) continue;

      GraphDataClass channel0 = GraphDataClass(rowsAsListOfValues[i][1], rowsAsListOfValues[i][6], rowsAsListOfValues[i][7]);
      // GraphDataClass channel1 = GraphDataClass(rowsAsListOfValues[i][1], rowsAsListOfValues[i][13], rowsAsListOfValues[i][14]);
      // GraphDataClass channel2 = GraphDataClass(rowsAsListOfValues[i][1], rowsAsListOfValues[i][20], rowsAsListOfValues[i][21]);
      flspots.add(FlSpot(i.toDouble(), rowsAsListOfValues[i][6]));
      // timeFlowPressure0.add(channel0);
      // timeFlowPressure1.add(channel1);
      // timeFlowPressure2.add(channel2);
      setState(() {
        setChartData();
      });
    }
  }

  void setChartData(){
    data =   LineChartData(
      lineTouchData: lineTouchData,
      gridData: gridData,
      borderData: borderData,
      lineBarsData: [
        LineChartBarData(
          spots: flspots,
          isCurved: true,
          color: const Color(0xff4af699),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
              show: false
          ),
          belowBarData: BarAreaData(show: false),
        )
      ],
    );
  }

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: const Border(
      bottom: BorderSide(color: Color(0xff4e4965), width: 4),
      left: BorderSide(color: Colors.transparent),
      right: BorderSide(color: Colors.transparent),
      top: BorderSide(color: Colors.transparent),
    ),
  );

  LineTouchData get lineTouchData => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
    ),
  );

  FlGridData get gridData => FlGridData(show: true);

  FlTitlesData get titlesData1 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    rightTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  SideTitles get bottomTitles => SideTitles(
    showTitles: true,
    // getTitlesWidget: bottomTitleWidgets,
  );

  // Widget bottomTitleWidgets(double value, TitleMeta meta) {
  SideTitles leftTitles() => SideTitles(
    getTitlesWidget: leftTitleWidgets,
    showTitles: true,
    interval: 1,
    reservedSize: 40,
  );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    return Text(value.toString(), style: style, textAlign: TextAlign.center);
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      data,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }
}

class GraphDataClass {
  String? time;
  double? flow;
  double? pressure;

  GraphDataClass(this.time, this.flow, this.pressure);
}