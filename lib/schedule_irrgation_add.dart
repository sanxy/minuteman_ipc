import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:minuteman_ipc/model/app_state.dart';
import 'package:minuteman_ipc/model/reminder.dart';
import 'PickerData.dart';

class ScheduleIrrigationPage extends StatefulWidget {
  final String title;
  final MyEvent event;
//  final double fontSize;

  const ScheduleIrrigationPage({
    Key key,
    this.title,
    this.event,
//    this.fontSize,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScheduleIrrigationPageState();
}

class ScheduleIrrigationPageState extends State<ScheduleIrrigationPage> {
  DateTime _pickedTime = DateTime.now();
  List<DateTime> _pickedDate = [
    DateTime.now(),
    DateTime.now().add(Duration(days: 7)),
  ];
  final double listSpec = 4.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String stateText;

  @override
  void initState() {
    super.initState();
//    if (widget.event.time != null) _pickedTime = widget.event.time;
//    if (widget.event.days != null) _pickedDate = widget.event.days;
//    if (widget.event.desc != null) _desc = widget.event.desc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('IRRIGATION'),
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.topCenter,
        child: ListView(
          children: <Widget>[
            (stateText != null) ? Text(stateText) : Container(),
            SizedBox(height: listSpec),
            RaisedButton(
              child: Text('Set Irrigation'),
              onPressed: () {
                showPickerModal(context);
              },
            ),
            SizedBox(
              height: listSpec,
            ),
          ],
        ),
      ),
    );
  }


  showPickerModal(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: JsonDecoder().convert(PickerData)),
        changeToFirst: true,
        hideHeader: false,
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {

          print(picker.adapter.text);

          saveData();
          returnHome();
        }).showModal(this.context);
    //_scaffoldKey.currentState);
  }

  void returnHome() {
// Go back to home/dashboard
    Navigator.pop(context);
    print("return home");
  }

  Future<void> saveData() async {
    await AppStateContainer.of(context).addEvent(
      MyEvent(
        widget.event.reminder,
        _pickedDate,
        _pickedTime,
//        desc: _controller.text,
        id: widget.event.id,
      ),
      oldEvent: widget.event,
    );
  }


}
