import 'package:flutter/material.dart';
import 'package:graph_demo/FlLineChart.dart';
import 'package:graph_demo/SFChart.dart';

import 'GoogleCharts.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Graph Demo App"),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: controller,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(15, 25, 15, 15),
                  child: ChartApp(),
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                ),
/*                Container(
                  margin: EdgeInsets.fromLTRB(15, 25, 15, 15),
                  child: SimpleTimeSeriesChart(),
                  height: MediaQuery.of(context).size.height/2,
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 25, 15, 15),
                  child: SimpleTimeSeriesChart(),
                  height: MediaQuery.of(context).size.height/2,
                  width: MediaQuery.of(context).size.width,
                ),*/
              ],
            ),
          ),
          Expanded(
              child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    controller.animateToPage(0,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeIn);
                  },
                  child: const Text("Valve 1"),
                  style: flatButtonStyle,
                ),
                TextButton(
                  onPressed: () {
                    controller.animateToPage(1,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeIn);
                  },
                  child: Text("Valve 2"),
                  style: flatButtonStyle,
                ),
                TextButton(
                  onPressed: () {
                    controller.animateToPage(2,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeIn);
                  },
                  child: Text("Valve 3"),
                  style: flatButtonStyle,
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
    backgroundColor: Colors.accents[1],
  );
}
