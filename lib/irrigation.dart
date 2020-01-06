import 'package:flutter/material.dart';

class Irrigation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return IrrigationState();
  }
}

class IrrigationState extends State<Irrigation> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("IRRIGATION"),
        backgroundColor: Colors.blue,
      ),
    );
  }
}