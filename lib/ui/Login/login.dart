import 'package:flutter/material.dart';
import 'package:notes/const.dart';
import 'package:notes/models/settings.dart';
import 'package:notes/ui/Home_Page/home_page.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Settings settings = Settings();

//////yeni guncellemeden dolayı data base guncellemesı yapılmalı
  String result = "";
  String passwordStr = "";

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // settings.currentColor = Color.fromARGB(
    //     255, 215, 215, 215); //////////////////////////////////////
    String password = settings.password;
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromARGB(255, 215, 215, 215),
        body: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildHeader(),
                buildTextForm(password),
                buildResult(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildHeader() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Text(
        "Parolanızı Giriniz",
        style: headerStyle3,
      ),
    );
  }

  buildTextForm(String password) {
    return Container(
      height: 200,
      width: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: TextFormField(
                obscureText: true,
                style: headerStyle4,
                decoration: InputDecoration(
                  hintText: "Parola",
                  prefixIcon: Icon(
                    Icons.lock,
                    color: generalColor,
                  ),
                ),
                onSaved: (String value) => passwordStr = value,
              ),
            ),
            buildSave(password),
          ],
        ),
      ),
    );
  }

  buildSave(String password) {
    return Padding(
      padding: EdgeInsets.only(right: 50, top: 30, left: 50),
      child: Container(
        height: 40,
        width: 80,
        decoration: BoxDecoration(
          color: Colors.grey.shade700,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: GestureDetector(
            child: Text(
              "Giriş",
              style: headerStyle11,
            ),
            onTap: () => enter(password),
          ),
        ),
      ),
    );
  }

  buildResult() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        result,
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      ),
    );
  }

  void enter(String password) {
    formKey.currentState.save();

    if (passwordStr == password) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      setState(() {
        result = "Yanlış Parola";
      });
    }
  }
}
