import 'package:flutter/material.dart';
import 'package:minuteman_ipc/model/app_state.dart';
import 'home.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';

//void main(){
//  runApp(new MaterialApp(
//    debugShowCheckedModeBanner: false,
//    title: "Minuteman IPC",
//    theme: new ThemeData(
//      primarySwatch: Colors.blue,
//    ),
//    home: new Home(),
//  ));
//}

void setupNotification() {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  var initializationSettingsAndroid =
  new AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings = new InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}

void main() async {
  setupNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('id');
    return AppStateContainer(
      [],
      [],
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Minuteman IPC',
        home: Home(),
      ),
    );
  }
}