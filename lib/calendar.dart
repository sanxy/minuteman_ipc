import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:minuteman_ipc/irrigation_add.dart';
import 'package:minuteman_ipc/model/app_state.dart';
import 'package:minuteman_ipc/model/reminder.dart';
import 'package:minuteman_ipc/model/reminder_irrigation.dart';
import 'package:minuteman_ipc/schedule_add.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CalendarState();
  }
}

class CalendarState extends State<Calendar> {
  DateTime _selectedDate = DateTime.now();
  List<MyEvent> appStateEvents = [];
  List<MyEvent2> appStateEvents2 = [];
  double fontSize = 12;

  bool hasLoadFromDb = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    loadData();
}

  void printHello() {
    final DateTime now = DateTime.now();
    final int isolateId = Isolate.current.hashCode;
    print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (builder) => Calendar()),
          (_) => false, // clean all back stack
    );
  }

  void loadData() async {
    if (!hasLoadFromDb) {
      await AppStateContainer.of(context).loadFromDb();
      hasLoadFromDb = true;
    }

    fontSize = await AppStateContainer.of(context).getFontSize();
    if (!mounted) return;
    setState(() {
      appStateEvents = AppStateContainer.of(context).readEvents();
    });
  }

  void loadData2() async {
    if (!hasLoadFromDb) {
      await AppStateContainer.of(context).loadFromDb();
      hasLoadFromDb = true;
    }

    fontSize = await AppStateContainer.of(context).getFontSize();
    if (!mounted) return;
    setState(() {
      appStateEvents2 = AppStateContainer.of(context).readEvents2();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CALENDAR', style: TextStyle(fontSize: fontSize + 4)),
      ),

      body:
      new OrientationBuilder(
        builder: (context, orientation) {
          return Column(
            children: <Widget>[
              Container(
                margin: orientation == Orientation.portrait ?
                EdgeInsets.symmetric(horizontal: 20.0) : EdgeInsets.symmetric(horizontal: 200.0),
                height: orientation == Orientation.portrait ? 330 : 200,
                child: CalendarCarousel<Event>(
                  headerTextStyle:
                  TextStyle(fontSize: fontSize + 5, color: Colors.blue),
                  weekdayTextStyle:
                  TextStyle(fontSize: fontSize, color: Colors.red),
                  onDayPressed: (DateTime date, List<Event> l) {
                    if (!mounted) return;
                    setState(() => _selectedDate = date);
                  },
                  weekendTextStyle: TextStyle(
                    color: Colors.red,
                  ),
                  locale: 'id',
                  thisMonthDayBorderColor: Colors.grey,
                  showHeaderButton: false,
                  selectedDateTime: _selectedDate,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child:
                Text('Schedule List', style: TextStyle(fontSize: fontSize + 4)),
              ),
              getScheduleList(),
            ],
          );
        },
      ),


    );
  }

  Widget getScheduleList() {
    // drop hour:minute:millisec etc
    _selectedDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );

    // print(event.days);
    final filteredEvents = appStateEvents.where((event) {
      print(event.days);
      return event.days[0] == _selectedDate ||
          event.days[1] == _selectedDate ||
          (_selectedDate.isAfter(event.days[0]) &&
              _selectedDate.isBefore(event.days[1]));
    }).toList();

    final filteredEvents2 = appStateEvents2.where((event) {
      print(event.days);
      return event.days[0] == _selectedDate ||
          event.days[1] == _selectedDate ||
          (_selectedDate.isAfter(event.days[0]) &&
              _selectedDate.isBefore(event.days[1]));
    }).toList();

    if (filteredEvents.length > 0) {
      return Expanded(
        child: ListView.builder(
          itemCount: filteredEvents.length,
          itemBuilder: (ctx, idx) => createScheduleRow(filteredEvents[idx]),
        ),
      );
    } else {
      return Expanded(
        child: Container(
          alignment: Alignment.center,
          child: Text(
            'No schedule',
            style:
            TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize + 2),
          ),
        ),
      );
    }
  }

  Widget getScheduleList2() {
    // drop hour:minute:millisec etc
    _selectedDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );

    // print(event.days);
    final filteredEvents2 = appStateEvents2.where((event) {
      print(event.days);
      return event.days[0] == _selectedDate ||
          event.days[1] == _selectedDate ||
          (_selectedDate.isAfter(event.days[0]) &&
              _selectedDate.isBefore(event.days[1]));
    }).toList();

    if (filteredEvents2.length > 0) {
      return Expanded(
        child: ListView.builder(
          itemCount: filteredEvents2.length,
          itemBuilder: (ctx, idx) => createScheduleRow2(filteredEvents2[idx]),
        ),
      );
    } else {
      return Expanded(
        child: Container(
          alignment: Alignment.center,
          child: Text(
            'No schedule',
            style:
            TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize + 2),
          ),
        ),
      );
    }
  }

  Widget createScheduleRow(MyEvent event) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: InkWell(
        onTap: () => onClick(event),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: <Widget>[
//              Icon(event.reminder.icons),
              Container(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(event.reminder.key,
                      style: TextStyle(fontSize: fontSize + 2)),
                  if (event.desc.isNotEmpty)
                    Text(
                      event.desc,
                      style: TextStyle(
                          fontWeight: FontWeight.w300, fontSize: fontSize),
                    )
                ],
              ),
              Expanded(child: Container()),
              Text("${DateFormat.Hm().format(event.time)}",
                  style: TextStyle(fontSize: fontSize + 2)),
            ],
          ),
        ),
      ),
    );
  }

  Widget createScheduleRow2(MyEvent2 event2) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: InkWell(
        onTap: () => onClick2(event2),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: <Widget>[
//              Icon(event.reminder.icons),
              Container(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(event2.reminder.key,
                      style: TextStyle(fontSize: fontSize + 2)),
                  if (event2.desc.isNotEmpty)
                    Text(
                      event2.desc,
                      style: TextStyle(
                          fontWeight: FontWeight.w300, fontSize: fontSize),
                    )
                ],
              ),
              Expanded(child: Container()),
              Text("${DateFormat.Hm().format(event2.time)}",
                  style: TextStyle(fontSize: fontSize + 2)),
            ],
          ),
        ),
      ),
    );
  }

  void onClick(MyEvent event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => SchedulePage(
          title: event.reminder.key.toUpperCase(),
          event: event,
          fontSize: fontSize,
        ),
      ),
    );
  }

  void onClick2(MyEvent2 event2) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => IrrigationPage(
          title: event2.reminder.key.toUpperCase(),
          event: event2,
          fontSize: fontSize,
        ),
      ),
    );
  }
}

//class HomeMenus extends StatelessWidget {
//  final double fontSize;
//
//  const HomeMenus({Key key, this.fontSize}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return GridView.builder(
//      shrinkWrap: true,
//      itemCount: reminderKinds.length,
//      itemBuilder: (ctx, idx) => FlatButton(
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.circular(6),
//          side: BorderSide(color: Colors.black12),
//        ),
//        color: Colors.white,
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Icon(reminderKinds[idx].icons),
//            Container(height: 8),
//            Text(
//              reminderKinds[idx].key,
//              textAlign: TextAlign.center,
//              style: TextStyle(fontSize: fontSize - 2),
//            )
//          ],
//        ),
//        onPressed: () => onClick(context, idx),
//      ),
//      padding: EdgeInsets.all(16),
//      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//        crossAxisCount: 3,
//        mainAxisSpacing: 8,
//        crossAxisSpacing: 8,
//        childAspectRatio: 1.2,
//      ),
//    );
//  }
//
//  void onClick(BuildContext context, int index) {
//    Navigator.push(
//      context,
//      MaterialPageRoute(
//        builder: (builder) => SchedulePage(
//          title: reminderKinds[index].key.toUpperCase(),
//          event: MyEvent(reminderKinds[index], null, null),
//          fontSize: fontSize,
//        ),
//      ),
//    );
//  }
//}