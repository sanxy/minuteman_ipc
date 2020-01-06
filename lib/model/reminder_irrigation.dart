import 'package:flutter/material.dart';

class ReminderIrrigation {
  final String key;

  ReminderIrrigation(this.key);

}

class MyEvent2 {
  final ReminderIrrigation reminder;
  final List<DateTime> days;
  final DateTime time;
  final String desc;
  int id;

  MyEvent2(this.reminder, this.days, this.time, {this.desc, this.id});

  Map<String, dynamic> toJson() {
    return {
      "reminder": reminder.key,
      "days": days.join(" - "),
      "time": time.toString(),
      "id": id,
      "desc": desc
    };
  }

  factory MyEvent2.parseJson(Map<String, dynamic> data) {

    final reminder =
        reminderIrrigationKinds.where((kind) => kind.key == data['reminder']).first;
    final days = data['days']
        .toString()
        .split(' - ')
        .map((day) => DateTime.tryParse(day))
        .toList();
    final time = DateTime.tryParse(data['time']);
    final id = data['id'];
    final desc = data['desc'];
    return MyEvent2(reminder, days, time, id: id, desc: desc);
  }
}

final allDays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

final reminderIrrigationKinds = [
  ReminderIrrigation(
    'Port 1',
  ),
  ReminderIrrigation(
    'Port 2',
  ),
  ReminderIrrigation(
    'Port 3',
  ),
  ReminderIrrigation(
    'Port 4',
  ),
  ReminderIrrigation(
    'Port 5',
  ),

  ReminderIrrigation(
    'Port 6',
  )
];



