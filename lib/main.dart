import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graph_demo/HomePage.dart';

void main() => runApp(GraphDemoApp());

class GraphDemoApp extends StatelessWidget {
  const GraphDemoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Graph Demo App",
      home: HomePage(),
    );
  }
}
