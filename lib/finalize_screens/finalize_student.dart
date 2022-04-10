import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stconnect/main.dart';
import 'dart:async';

class FinalizeStudent extends StatefulWidget {
  final email;
  final password;
  final username;
  FinalizeStudent({
    this.email,
    this.password,
    this.username,
  });
  @override
  _FinalizeStudentState createState() => _FinalizeStudentState();
}

class _FinalizeStudentState extends State<FinalizeStudent> {
  String message = "Finalizing......";
  bool iserror = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    register();
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      if (user != null) {
        writetodatabase(user.uid);
        writetolocaldb();
        pause_and_go();
      }
    });
  }

  void register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: widget.email, password: widget.password);
    } catch (e) {
      CoolAlert.show(
          context: context, type: CoolAlertType.error, text: e.message);
      setState(() {
        message = e.message;
        iserror = true;
      });
    }
  }

  void writetodatabase(String uid) async {
    // print(uid);
    try {
      await Firestore.instance
          .collection("users")
          .document(uid)
          .setData({"username": widget.username, "account_type": "student"});
    } catch (e) {
      print(e.message);
    }
  }

  void writetolocaldb() {
    var box = Hive.box("account");
    box.put("username", widget.username);
    box.put("account_type", "student");
  }

  void pause_and_go() {
    Timer(Duration(seconds: 3), () {
      Navigator.popUntil(
          context, ModalRoute.withName(Navigator.defaultRouteName));
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
                  },
                  child: Text("Retry"),
                ),
              ),
            )
          : Center(
              child: TypewriterAnimatedTextKit(
                repeatForever: true,
                text: [
                  "Creating account for ${widget.username}.....",
                  "Account type : student",
                  "Saving your data.....",
                  "Creating account......"
                ],
                textStyle: TextStyle(color: Colors.blue),
              ),
            ),
    );
  }
}
