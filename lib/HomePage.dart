import 'package:flutter/material.dart';
import 'package:graph_demo/FlLineChart.dart';
import 'package:graph_demo/SFChart.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'GoogleCharts.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController controller = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Graph Demo App"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: PageView(
              controller: controller,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(5, 25, 5, 15),
                  child: ChartApp(0),
                  // height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(5, 25, 5, 15),
                  child: ChartApp(1),
                  // height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(5, 25, 5, 15),
                  child: ChartApp(2),
                  // height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                ),
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(top: 20),
                alignment: Alignment.topCenter,
                child: SmoothPageIndicator(
                  controller: controller,
                  count: 3,
                  effect: ScrollingDotsEffect(
                      dotHeight: 12,
                      dotWidth: 12,
                      dotColor: Colors.grey,
                      activeDotColor: Colors.accents[1]
                      // strokeWidth: 5,
                      ),
                ),
                /*child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        controller.animateToPage(0,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeIn);
                      },
                      child: const Text("Valve 1"),
                      style: currentPage == 0
                          ? flatButtonStyle
                          : flatButtonStyleUnselected,
                    ),
                    TextButton(
                      onPressed: () {
                        controller.animateToPage(1,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeIn);
                      },
                      child: Text("Valve 2"),
                      style: currentPage == 1
                          ? flatButtonStyle
                          : flatButtonStyleUnselected,
                    ),
                    TextButton(
                      onPressed: () {
                        controller.animateToPage(2,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeIn);
                      },
                      child: Text("Valve 3"),
                      style: currentPage == 2
                          ? flatButtonStyle
                          : flatButtonStyleUnselected,
                    )
                  ],
                ),*/
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

  ButtonStyle flatButtonStyleUnselected = TextButton.styleFrom(
    primary: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
    backgroundColor: Colors.grey,
  );
}
