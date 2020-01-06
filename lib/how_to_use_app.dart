import 'package:flutter/material.dart';

class HowToUseApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HowToUseAppState();
  }
}

class HowToUseAppState extends State<HowToUseApp> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("HOW TO USE APP"),
        backgroundColor: Colors.blue,
      ),
    );
  }
}