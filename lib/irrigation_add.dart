
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:minuteman_ipc/model/app_state.dart';
//import 'package:minuteman_ipc/model/reminder.dart';
import 'package:minuteman_ipc/model/reminder_irrigation.dart';
import 'package:recase/recase.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class IrrigationPage extends StatefulWidget {
  final String title;
  final MyEvent2 event;
  final double fontSize;

  const IrrigationPage({
    Key key,
    this.title,
    this.event,
    this.fontSize,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => IrrigationPageState();
}

class IrrigationPageState extends State<IrrigationPage> {
  TextEditingController _controller = TextEditingController();
  DateTime _pickedTime = DateTime.now();
  List<DateTime> _pickedDate = [
    DateTime.now(),
    DateTime.now().add(Duration(days: 7)),
  ];
  String _desc = '';

  @override
  void initState() {
    super.initState();
    if (widget.event.time != null) _pickedTime = widget.event.time;
    if (widget.event.days != null) _pickedDate = widget.event.days;
    if (widget.event.desc != null) _desc = widget.event.desc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ReCase(widget.title).titleCase)),
      body: ListView(
        children: <Widget>[
          Container(height: 18),
//          Center(child: Icon(widget.event.reminder.icons, size: 80)),
          Container(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              maxLines: 1,
              controller: _controller..text = _desc,
              onChanged: (str) => _desc = str,
              style: TextStyle(fontSize: widget.fontSize),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  labelText: 'Detail Activity',
                  hasFloatingPlaceholder: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
          ),
          Container(height: 18),
          Builder(
            builder: (ctx) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: buildActionButton(
                'Set Date',
                getDaySelected(),
                    () => showCalendarPicker(ctx),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: buildActionButton(
              'Set Hour',
              _pickedTime == null
                  ? '00:00'
                  : '${DateFormat.Hm().format(_pickedTime)}',
              showTimePicker,
            ),
          ),
          Container(height: 120),
          Center(
            child: RaisedButton(
              color: Colors.cyan,
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.fontSize,
                ),
              ),
              onPressed: () async {
                await AppStateContainer.of(context).addEvent2(
                  MyEvent2(
                    widget.event.reminder,
                    _pickedDate,
                    _pickedTime,
                    desc: _controller.text,
                    id: widget.event.id,
                  ),
                  oldEvent2: widget.event,
                );
                if (widget.event.id == null) Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ),
          if (widget.event.id != null)
            Center(
              child: RaisedButton(
                color: Colors.amberAccent,
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: widget.fontSize,
                  ),
                ),
                onPressed: () {
                  AppStateContainer.of(context).deleteEvent2(widget.event);
                  Navigator.of(context).pop();
                },
              ),
            ),
        ],
      ),
    );
  }

  FlatButton buildActionButton(
      String caption,
      String selection,
      VoidCallback callback,
      ) {
    return FlatButton(
      onPressed: callback,
      color: Colors.blue,
      child: Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                caption,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.fontSize,
                ),
              ),
              Expanded(child: Container()),
              Text(
                selection,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.fontSize,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

//  void showTimePicker() {
//    DatePicker.showPicker(context,
//        showTitleActions: true,
//        onChanged: (date) {
//          print('change $date');
//        }, onConfirm: (date) {
//          print('confirm $date');
//        },
//        pickerModel: CustomPicker(
//            currentTime: DateTime.now(),
//            locale: LocaleType.en));
////      pickerTheme: DateTimePickerTheme(
////        cancel: Text('Canceled'),
////        confirm: Text('Save', style: TextStyle(color: Colors.blueAccent)),
////      ),
////    );
//  }

  void showTimePicker() {
    DatePicker.showDatePicker(
      context,
      dateFormat: 'HH:mm',
      pickerMode: DateTimePickerMode.time,
      onConfirm: (date, list) {
        if (!mounted) return;
        setState(() {
          _pickedTime = date;
        });
      },
      pickerTheme: DateTimePickerTheme(
        cancel: Text('Canceled'),
        confirm: Text('Save', style: TextStyle(color: Colors.blueAccent)),
      ),
    );
  }

  void showCalendarPicker(BuildContext ctx) async {
    final pickedDate = await DateRagePicker.showDatePicker(
      context: ctx,
      initialFirstDate: _pickedDate[0],
      initialLastDate: _pickedDate[1],
      firstDate: new DateTime(2000),
      lastDate: new DateTime(2040),
    );
    if (pickedDate == null) {
      return;
    } else {
      if (pickedDate.length == 1) {
        pickedDate.add(pickedDate[0]);
      }
      setState(() {
        _pickedDate = pickedDate;
      });
    }
  }

  String getDaySelected() {
    final start = _pickedDate[0];
    final stop = _pickedDate[1];
    final startStr = DateFormat.yMMMd().format(start);
    final stopStr = DateFormat.yMMMd().format(stop);
    return (startStr == stopStr) ? '$startStr' : '$startStr - $stopStr';
  }
}

//class CustomPicker extends CommonPickerModel {
//  String digits(int value, int length) {
//    return '$value'.padLeft(length, "0");
//  }
//
//  CustomPicker({DateTime currentTime, LocaleType locale}) : super(locale: locale) {
//    this.currentTime = currentTime ?? DateTime.now();
//    var _dayPeriod = 0;
//    this.setLeftIndex(this.currentTime.hour);
//    this.setMiddleIndex(this.currentTime.minute);
//    this.setRightIndex(_dayPeriod);
//    _fillRightList();
//  }
//
//  @override
//  String leftStringAtIndex(int index) {
//    if (index >= 1 && index < 13) {
//      return this.digits(index, 2);
//    } else {
//      return null;
//    }
//  }
//
//  @override
//  String middleStringAtIndex(int index) {
//    if (index >= 0 && index < 60) {
//      return this.digits(index, 2);
//    } else {
//      return null;
//    }
//  }
//
//  @override
//  String rightStringAtIndex(int index) {
//    if (index == 0) {
//      return 'AM';
//    } else if (index == 1) {
//      return 'PM';
//    }
//    return null;
//  }
//
//  void _fillRightList() {
//    this.rightList = List.generate(2, (int index) {
//      return '$index';
//    });
//  }
//
//  @override
//  void setRightIndex(int index) {
//    super.setRightIndex(index);
//    _fillRightList();
//  }
//
//  @override
//  String leftDivider() {
//    return ":";
//  }
//
//  @override
//  String rightDivider() {
//    return " ";
//  }
//
//  @override
//  List<int> layoutProportions() {
//    return [1, 1, 1];
//  }
//
//  @override
//  DateTime finalTime() {
//    return currentTime.isUtc
//        ? DateTime.utc(currentTime.year, currentTime.month, currentTime.day,
//        this.currentLeftIndex(), this.currentMiddleIndex(), this.currentRightIndex())
//        : DateTime(currentTime.year, currentTime.month, currentTime.day, this.currentLeftIndex(),
//        this.currentMiddleIndex(), this.currentRightIndex());
//  }
//}
