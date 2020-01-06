import 'package:flutter/material.dart';
import 'package:minuteman_ipc/email/email_set_up.dart';
import 'package:minuteman_ipc/irrigation_add.dart';
import 'package:minuteman_ipc/model/reminder.dart';
import 'package:minuteman_ipc/model/reminder_irrigation.dart';
import 'package:minuteman_ipc/schedule_add.dart';
import 'package:minuteman_ipc/services/authentication.dart';
import 'settings.dart';
import 'calendar.dart';
import 'how_to_use_app.dart';


class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {

  double fontSize = 12;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Minuteman IPC"),
      ),
      backgroundColor: Colors.blueGrey,
      body: new OrientationBuilder(
        builder: (context, orientation) {
          return new GridView.count(
            // Create a grid with 2 columns in portrait mode, or 3 columns in
            children: <Widget>[
              //Settings
              GestureDetector(
                onTap: () {
                  navigateToSettings();
                  debugPrint("settings clicked");
                },
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, //add this
                    children: <Widget>[
                      Expanded(
                        child: Image.asset(
                          'images/settings.jpeg',
                          fit: BoxFit.cover, // add this
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text("SETTINGS"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //Pest control feed
              GestureDetector(
                onTap: () =>
                // show bottom sheet with menu items
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext ctx) {
                      return HomeMenus(fontSize: fontSize);
                    }),

                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, //add this
                    children: <Widget>[
                      Expanded(
                        child: Image.asset(
                          'images/pestcontrol.jpeg',
                          fit: BoxFit.cover, // add this
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text("PEST CONTROL FEED"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //Calendar
              GestureDetector(
                onTap: () => navigateToCalendar(),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, //add this
                    children: <Widget>[
                      Expanded(
                        child: Image.asset(
                          'images/calendar.jpeg',
                          fit: BoxFit.cover, // add this
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text("CALENDAR"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //Irrigation
              GestureDetector(
                onTap: () =>
                // show bottom sheet with menu items
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext ctx) {
                      return HomeMenus(fontSize: fontSize);
                    }),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, //add this
                    children: <Widget>[
                      Expanded(
                        child: Image.asset(
                          'images/irrigation.jpeg',
                          fit: BoxFit.cover, // add this
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text("IRRIGATION"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //Email
              GestureDetector(
                onTap: () => navigateToEmail(),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, //add this
                    children: <Widget>[
                      Expanded(
                        child: Image.asset(
                          'images/email.jpeg',
                          fit: BoxFit.cover, // add this
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text("EMAIL"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //How to use app
              GestureDetector(
                onTap: () => navigateToHowToUseApp(),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, //add this
                    children: <Widget>[
                      Expanded(
                        child: Image.asset(
                          'images/howtouseapp.jpeg',
                          fit: BoxFit.cover, // add this
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text("HOW TO USE APP"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
            // landscape mode.
            crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
            childAspectRatio: orientation == Orientation.portrait ? 8.0 / 8.8 : 6.0/4.2,
            padding: orientation == Orientation.portrait ? EdgeInsets.all(4.0) : EdgeInsets.all(1.0),
          );
        },
      ),

    );
  }

  void navigateToSettings() =>
    Navigator.of(context).push(new PageRouteBuilder(pageBuilder: (_, __, ___)
    => new Settings(auth: new Auth())));

  navigateToCalendar() =>
      Navigator.of(context).push(new PageRouteBuilder(pageBuilder: (_, __, ___)
      => new Calendar()));

  navigateToEmail() =>
      Navigator.of(context).push(new PageRouteBuilder(pageBuilder: (_, __, ___)
      => new EmailSetUp(auth: new Auth())));

  navigateToHowToUseApp() =>
      Navigator.of(context).push(new PageRouteBuilder(pageBuilder: (_, __, ___)
      => new HowToUseApp()));

}


class HomeMenus extends StatelessWidget {
  final double fontSize;

  const HomeMenus({Key key, this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: reminderKinds.length,
      itemBuilder: (ctx, idx) => FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: Colors.black12),
        ),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(height: 8),
            Text(
              reminderKinds[idx].key,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: fontSize - 2),
            )
          ],
        ),
        onPressed: () => onClick(context, idx),
      ),
      padding: EdgeInsets.all(4),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 2,
        crossAxisSpacing: 4,
        childAspectRatio: 1.8,
      ),
    );
  }

  void onClick(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => SchedulePage(
          title: reminderKinds[index].key.toUpperCase(),
          event: MyEvent(reminderKinds[index], null, null),
          fontSize: fontSize,
        ),
      ),
    );
  }
}

class HomeIrrigationMenus extends StatelessWidget {
  final double fontSize;

  const HomeIrrigationMenus({Key key, this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: reminderIrrigationKinds.length,
      itemBuilder: (ctx, idx) => FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: Colors.black12),
        ),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
//            Icon(reminderIrrigation[idx].icons),
            Container(height: 8),
            Text(
              reminderIrrigationKinds[idx].key,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: fontSize - 2),
            )
          ],
        ),
        onPressed: () => onClickTwo(context, idx),
      ),
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.2,
      ),
    );
  }

  void onClickTwo(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => IrrigationPage(
          title: reminderIrrigationKinds[index].key.toUpperCase(),
          event: MyEvent2(reminderIrrigationKinds[index], null, null),
          fontSize: fontSize,
        ),
      ),
    );
  }
}