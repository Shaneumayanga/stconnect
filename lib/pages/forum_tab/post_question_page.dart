import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stconnect/pages/Main_page.dart';
import 'package:stconnect/utils/constants.dart';
import 'package:stconnect/utils/global_variables.dart';
import 'package:uuid/uuid.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

class PostQuestion extends StatefulWidget {
  @override
  _PostQuestionState createState() => _PostQuestionState();
}

class _PostQuestionState extends State<PostQuestion> {
  TextEditingController titletextcontroller = TextEditingController();
  TextEditingController descripiontextcontroller = TextEditingController();
  String uid = "";
  bool ispostingquestion = false;

  List<String> subjects = [
    "Econ",
    "Logic",
    "ICT",
    "English",
    "Accounting",
    "Physics",
    "Maths",
    "Chemistry",
    "Biology",
    "Geography",
    "Sinhala",
    "Tamil",
    "Business"
  ];

  var selectedsub;
  var username;
  var account_type;

  late DateTime dateTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //default is "All"
    FacebookAudienceNetwork.init();
    selectedsub = subjects[0];
    getaccountdata();
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      uid = user.uid;
    });
    dateTime = DateTime.now();

    showad();
  }

  Widget buildbox(double h) {
    return SizedBox(
      height: h,
    );
  }

  void showad() {
    if (!isapptesting) {
      FacebookInterstitialAd.loadInterstitialAd(
        placementId: "216703189834407_217733029731423",
        listener: (result, value) {
          if (result == InterstitialAdResult.LOADED) {
            FacebookInterstitialAd.showInterstitialAd(delay: 500);
          }
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    FacebookAudienceNetwork.destroyInterstitialAd();
  }

  void getaccountdata() {
    Timer(Duration(seconds: 2), () {
      var box = Hive.box("account");
      if (box != null) {
        var username = box.get("username");
        var account_type = box.get("account_type");
        print(account_type);
        setState(() {
          this.username = username;
          this.account_type = account_type;
        });
      }
    });
  }

  void postQuestion() async {
    String title = titletextcontroller.text;
    String description = descripiontextcontroller.text;
    if (title != "" && description != "") {
      String docid = Uuid().v4();
      setState(() {
        ispostingquestion = true;
      });
      //Docid == Question_id
      try {
        await Firestore.instance
            .collection("questions")
            .document(docid)
            .setData({
          "title": title,
          "description": description,
          "owner_uid": this.uid,
          "account_type": this.account_type,
          "poster_usrename": this.username,
          "subject": this.selectedsub,
          "question_id": docid,
          "datetime": this.dateTime,
        });

        titletextcontroller.clear();
        descripiontextcontroller.clear();
        Navigator.popUntil(
            context, ModalRoute.withName(Navigator.defaultRouteName));
        CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            title: "Your question has been posted!");
      } catch (e) {
        print(e.toString());
        setState(() {
          ispostingquestion = false;
        });
        CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: "An error occurred");
      }
    } else {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: "Some fields are empty");
    }
  }

  Widget buildsubjectseletor() {
    return Container(
      decoration: kBoxTeacherCardDecorationStyle,
      child: DropdownButtonHideUnderline(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            value: selectedsub,
            dropdownColor: Colors.blue,
            items: subjects.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w400),
                ),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                this.selectedsub = val;
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: double.infinity,
        child: Scaffold(
            appBar: AppBar(
              title: Text("New Question"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  TextField(
                    maxLength: 40,
                    controller: titletextcontroller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Title"),
                  ),
                  buildbox(10),
                  TextField(
                    controller: descripiontextcontroller,
                    maxLength: 500,
                    maxLines: 10,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Description"),
                  ),
                  buildbox(12),
                  buildsubjectseletor(),
                  buildbox(8),
                  ispostingquestion
                      ? Container(
                          child: Center(child: Text("Posting....")),
                        )
                      : RaisedButton.icon(
                          onPressed: postQuestion,
                          icon: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                          label: Text("Post Question",
                              style: TextStyle(color: Colors.white)),
                          color: Colors.blue,
                        ),
                ],
              ),
            )),
      ),
    );
  }
}
