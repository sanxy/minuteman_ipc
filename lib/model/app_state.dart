import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:minuteman_ipc/model/reminder.dart';
import 'package:minuteman_ipc/model/reminder_irrigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateContainer extends InheritedWidget {
  final List<MyEvent> _events;
  final List<MyEvent2> _events2;
  final Widget child;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AppStateContainer(this._events, this._events2, this.child);

  Future<void> setupNotification(MyEvent event) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'stage_alarm', 'Alarm Stage', 'Alarm scheduling activity');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    DateTime start = event.days[0];
    DateTime last = event.days[1];
    int i = 0;

    while (!start.isAfter(last)) {
      final time = start.add(Duration(
        hours: event.time.hour,
        minutes: event.time.minute,
      ));
      await flutterLocalNotificationsPlugin.schedule(
        event.id - i,
        event.reminder.key,
        event.desc,
        time,
        platformChannelSpecifics,
      );

      start = start.add(Duration(days: 1));
      i += 1;
    }
  }

  Future<void> addEvent(MyEvent event, {MyEvent oldEvent}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // drop time hour:minute:millisec
    event.days[0] = DateTime(
      event.days[0].year,
      event.days[0].month,
      event.days[0].day,
    );
    event.days[1] = DateTime(
      event.days[1].year,
      event.days[1].month,
      event.days[1].day,
    );

    if (event.id != null) {
      _events.removeWhere((evn) => evn.id == event.id);
      // cancel all event before
      print('cancel but reset');
      for (var i = 0; i < oldEvent.days.length; i++) {
        await flutterLocalNotificationsPlugin.cancel(oldEvent.id - i);
      }
    }

    int counter = event.days.length;
    if (prefs.containsKey('eventCounter')) {
      counter += prefs.getInt('eventCounter');
    }
    event.id = counter;
    await prefs.setInt('eventCounter', counter);

    _events.add(event);
    _events.sort((evtA, evtB) => evtA.time.isBefore(evtB.time) ? -1 : 1);

    // save to pref
    final jsonList = _events.map((event) => event.toJson()).toList();
    final data = jsonEncode(jsonList);
    prefs.setString('schedule', data);

    // schedule reminder
    if (event.id != null) {
//      await setupNotification(event);
    }
//    await setupNotification(event);
  }

  Future<void> addEvent2(MyEvent2 event2, {MyEvent2 oldEvent2}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // drop time hour:minute:millisec
    event2.days[0] = DateTime(
      event2.days[0].year,
      event2.days[0].month,
      event2.days[0].day,
    );
    event2.days[1] = DateTime(
      event2.days[1].year,
      event2.days[1].month,
      event2.days[1].day,
    );

    if (event2.id != null) {
      _events2.removeWhere((evn) => evn.id == event2.id);
      // cancel all event before
      print('cancel but reset');
      for (var i = 0; i < oldEvent2.days.length; i++) {
        await flutterLocalNotificationsPlugin.cancel(oldEvent2.id - i);
      }
    }

    int counter = event2.days.length;
    if (prefs.containsKey('eventCounter')) {
      counter += prefs.getInt('eventCounter');
    }
    event2.id = counter;
    await prefs.setInt('eventCounter', counter);

    _events2.add(event2);
    _events2.sort((evtA, evtB) => evtA.time.isBefore(evtB.time) ? -1 : 1);

    // save to pref
    final jsonList = _events.map((event) => event2.toJson()).toList();
    final data = jsonEncode(jsonList);
    prefs.setString('schedule', data);

    // schedule reminder
    if (event2.id != null) {
//      await setupNotification(event);
    }
//    await setupNotification(event);
  }

  Future<void> saveFontSize(double size) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', size);
  }

  Future<double> getFontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double fontSize = 12;
    if (prefs.containsKey('fontSize')) {
      fontSize = prefs.getDouble('fontSize');
    }
    return fontSize;
  }

  void deleteEvent(MyEvent event) async {
    print(event);
    if (event.id == null) return;

    print(_events);
    _events.removeWhere((evn) {
      print(evn.id);
      print(event.id);
      return evn.id == event.id;
    });
    print(_events);

    // save to pref
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonList = _events.map((event) => event.toJson()).toList();
    final data = jsonEncode(jsonList);

    print(data);
    prefs.setString('schedule', data);

    // remove reminder
    print('cancel reminder');
    for (var i = 0; i < event.days.length; i++) {
      await flutterLocalNotificationsPlugin.cancel(event.id - i);
    }
  }

  void deleteEvent2(MyEvent2 event2) async {
    print(event2);
    if (event2.id == null) return;

    print(_events2);
    _events2.removeWhere((evn) {
      print(evn.id);
      print(event2.id);
      return evn.id == event2.id;
    });
    print(_events2);

    // save to pref
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonList = _events.map((event) => event.toJson()).toList();
    final data = jsonEncode(jsonList);

    print(data);
    prefs.setString('schedule', data);

    // remove reminder
    print('cancel reminder');
    for (var i = 0; i < event2.days.length; i++) {
      await flutterLocalNotificationsPlugin.cancel(event2.id - i);
    }
  }

  Future<List<MyEvent>> loadFromDb() async {
    // load from pref
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('schedule');
    if (data != null) {
      final jsonList = jsonDecode(data) as List<dynamic>;
      final events = jsonList.map((item) => MyEvent.parseJson(item)).toList();
      _events.clear();
      _events.addAll(events);
    }
    return _events;
  }

  Future<List<MyEvent2>> loadFromDb2() async {
    // load from pref
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('schedule');
    if (data != null) {
      final jsonList = jsonDecode(data) as List<dynamic>;
      final events2 = jsonList.map((item) => MyEvent2.parseJson(item)).toList();
      _events2.clear();
      _events2.addAll(events2);
    }
    return _events2;
  }

  List<MyEvent> readEvents() => _events;

  List<MyEvent2> readEvents2() => _events2;

  static AppStateContainer of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AppStateContainer);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
