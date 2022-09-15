import 'package:flutter/material.dart';
import 'package:notes/common_widget/merkez_widget.dart';
import 'package:notes/models/settings.dart';
import 'package:notes/models/settingsdb.dart';
import 'package:notes/services/database_helper.dart';
import 'package:notes/ui/Home_Page/home_page.dart';
import 'package:notes/ui/Login/login.dart';

class LandingPage extends StatefulWidget {
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  bool flag = false;
  Settings settings = Settings();
  @override
  void initState() {
    super.initState();
    read().then((value) => flag = value);
  }

  @override
  Widget build(BuildContext context) {
    if (settings.currentColor != null && settings.sort != null) {
      if (flag) {
        return Login();
      } else {
        return HomePage();
      }
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: MerkezWidget(children: [
          Image.asset(
            "assets/icon.png",
            height: 100,
            width: 100,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          CircularProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          )
        ]),
      );
    }
  }

  Future<bool> read() async {
    SettingsDb settingsDb = await databaseHelper.getSettings();
    settings.password = settingsDb.password;
    try {
      int color = int.parse(settingsDb.theme);
      settings.currentColor = Color(color);
    } catch (_) {
      settings.currentColor = Color(4293914607);
    }
    try {
      settings.sort = settingsDb.sort;
    } catch (_) {
      settings.sort = "3/1";
    }
    try {
      settings.visibility = settingsDb.visibility;
    } catch (_) {
      settings.visibility = 1;
    }
    setState(() {});
    return settings.password != null &&
        settings.password.isNotEmpty &&
        settings.password != "";
  }
}
