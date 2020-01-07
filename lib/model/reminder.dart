import 'package:flutter/material.dart';

class Reminder {
  final String key;

  Reminder(this.key);

}

class MyEvent {
  final Reminder reminder;
  final List<DateTime> days;
  final DateTime time;
  final String desc;
  int id;

  MyEvent(this.reminder, this.days, this.time, {this.desc, this.id});

  Map<String, dynamic> toJson() {
    return {
      "reminder": reminder.key,
      "days": days.join(" - "),
      "time": time.toString(),
      "id": id,
      "desc": desc
    };
  }

  factory MyEvent.parseJson(Map<String, dynamic> data) {

    final reminder =
        reminderKinds.where((kind) => kind.key == data['reminder']).first;
    final days = data['days']
        .toString()
        .split(' - ')
        .map((day) => DateTime.tryParse(day))
        .toList();
    final time = DateTime.tryParse(data['time']);
    final id = data['id'];
    final desc = data['desc'];
    return MyEvent(reminder, days, time, id: id, desc: desc);
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

final reminderKinds = [
  Reminder(
    'Zone 1',
  ),
  Reminder(
    'Zone 2',
  ),
  Reminder(
    'Zone 3',
  ),
  Reminder(
    'Zone 4',
  ),
  Reminder(
    'Zone 5',
  ),

  Reminder(
    'Zone 6',
  )
];




