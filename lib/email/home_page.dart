import 'package:flutter/material.dart';
import 'package:minuteman_ipc/services/authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String userEmail;

  // get email saved in shared prefs
  loadSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = (prefs.getString('email_key') ?? "");
      print(userEmail);
    });

  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();

    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Logged In'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: signOut)
          ],
        ),
        body: userEmail != null
            ? Center(
              child: Text(
                  "Welcome back: $userEmail",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0),
                ),
            )
            : Container());
  }

  @override
  void initState() {
    super.initState();
    restore();
  }

  restore() async {
    setState(() {
      loadSharedPrefs();
    });
  }
}
