import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stconnect/pages/Login_page.dart';

import '../main.dart';

class FinalizeLogin extends StatefulWidget {
  final email;
  final password;
  FinalizeLogin({this.email, this.password});

  @override
  _FinalizeLoginState createState() => _FinalizeLoginState();
}

class _FinalizeLoginState extends State<FinalizeLogin> {
  bool iserror = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    login();
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      if (user != null) {
        getdetailsfromfirestore(user.uid);
      }
    });
  }

  void login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: widget.email, password: widget.password);
    } catch (e) {
      CoolAlert.show(
          context: context, type: CoolAlertType.error, text: e.message);
      setState(() {
        iserror = true;
      });
    }
  }

  void getdetailsfromfirestore(String uid) async {
    try {
      var account = await Firestore.instance
          .collection("users")
          .document(uid)
          .get()
          .then((data) {
        var usename = data['username'];
        print(usename);
        var account_type = data['account_type'];
        print(account_type);
        writetolocaldb(usename, account_type);
        pause_and_go();
      });
    } catch (e) {
      print(e.message);
    }
  }

  void writetolocaldb(String username, String account_type) {
    var box = Hive.box("account");
    box.put("username", username);
    box.put("account_type", account_type);
    print("wrote to local db");
  }

  void pause_and_go() {
    Timer(Duration(seconds: 3), () {
      // Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MyApp();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: iserror
          ? Container(
              child: Center(
                child: RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LoginPage();
                    }));
                  },
                  child: Text("Retry"),
                ),
              ),
            )
          : Center(
              child: TypewriterAnimatedTextKit(
                repeatForever: true,
                text: ["Logging you in....", "Fetching your data...."],
                textStyle: TextStyle(color: Colors.blue),
              ),
            ),
    );
  }
}
