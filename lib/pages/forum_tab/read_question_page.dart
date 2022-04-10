import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:hive/hive.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:stconnect/pages/View_teacher_page.dart';
import 'package:stconnect/pages/forum_tab/answertile.dart';
import 'package:uuid/uuid.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:stconnect/utils/constants.dart';
import 'dart:async';

class ReadQuestionPage extends StatefulWidget {
  final title;
  final description;
  final question_id;
  final poster_username;
  final subject;
  final posted_question_owner_uid;
  ReadQuestionPage(
      {this.title,
      this.description,
      this.question_id,
      this.poster_username,
      this.subject,
      this.posted_question_owner_uid});
  @override
  _ReadQuestionPageState createState() => _ReadQuestionPageState();
}

class _ReadQuestionPageState extends State<ReadQuestionPage> {
  TextEditingController answertext = TextEditingController();

  TextStyle descriptionstyle = TextStyle(
      color: Colors.black54, fontSize: 15.0, fontWeight: FontWeight.w700);

  TextStyle namestyle = TextStyle(color: Colors.black54, fontSize: 12.0);
  String uid;

  var username;
  var account_type;

  bool ispostinganswer = false;

  @override
  initState() {
    super.initState();
    getaccountdata();
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      uid = user.uid;
    });
  }

  //Get data from hive to put in the Notification data and the answer data:
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

  void postanswer() async {
    var docid = Uuid().v4();
    if (answertext.text != "") {
      setState(() {
        ispostinganswer = true;
      });
      try {
        await Firestore.instance
            .collection("answers")
            .document(widget.question_id)
            .collection("answers")
            .document(docid)
            .setData({
          "owner_uid": this.uid,
          "answer": answertext.text,
          "poster_name": this.username,
          "poster_account_type": this.account_type,
          "answer_id": docid,
        });
      } catch (e) {
        print(e.message);
      }

      //send the notification
      sendNotification();
      answertext.clear();
      Navigator.pop(context);
      showanswerspopup();
      CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          title: "Answer posted!");
    } else {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.info,
          title: "Please enter an answer");
    }
  }

  void sendNotification() async {
    //Notification Id:
    var id = Uuid().v4();
    //So they won't send them self notification for there own questions:
    if (this.uid != widget.posted_question_owner_uid) {
      await Firestore.instance
          .collection("notifications")
          .document(widget.posted_question_owner_uid)
          .collection("notifications")
          .document(id)
          .setData({
        "by_uid": this.uid,
        "account_type": this.account_type,
        "question_title": widget.title,
        "username": this.username,
        "question_id": widget.question_id,
        "type:": "posted_answer"
      });
    }
  }

  void openteacher(poster_account_uid) async {
    await Firestore.instance
        .collection("teachers")
        .document(poster_account_uid)
        .get()
        .then((documentsnapshot) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ViewTeacherPage(
          username: documentsnapshot['username'],
          phonenumber: documentsnapshot['phonenumber'],
          uid: documentsnapshot['uid'],
          email: documentsnapshot['email'],
          subjects: documentsnapshot['subjects'],
          bio: documentsnapshot['bio'] == null
              ? "No bio"
              : documentsnapshot['bio'],
        );
      }));
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Liked"),
      content: Text("Like sent"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void sendlikenotification(posted_answer_owner_uid) async {
    String uid = Uuid().v4();
    await Firestore.instance
        .collection("notifications")
        .document(posted_answer_owner_uid)
        .collection("notifications")
        .document(uid)
        .setData({
      "likedby": this.uid,
      "liked_by_name": this.username,
      "question": widget.title,
      "type": "answerlike",
    });
    showAlertDialog(context);
  }

  Widget answersstreambuilder() {
    return Container(
      height: MediaQuery.of(context).size.height * (70 / 100),
      child: StreamBuilder(
          stream: Firestore.instance
              .collection("answers")
              .document(widget.question_id)
              .collection("answers")
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return ListView(
                children: [
                  ListTileShimmer(
                    isDisabledAvatar: true,
                  ),
                  ListTileShimmer(
                    isDisabledAvatar: true,
                  ),
                  ListTileShimmer(
                    isDisabledAvatar: true,
                  ),
                  ListTileShimmer(
                    isDisabledAvatar: true,
                  ),
                  ListTileShimmer(
                    isDisabledAvatar: true,
                  ),
                  ListTileShimmer(
                    isDisabledAvatar: true,
                  ),
                  ListTileShimmer(
                    isDisabledAvatar: true,
                  ),
                ],
              );
            }

            var data;
            data = snapshot.data.documents;
            List<Widget> answertiles = [];
            answertiles.add(
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: Colors.black54,
                ),
                title: Text(
                  "Answers ${data.length}",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            );
            answertiles.add(Divider());

            for (var d in data) {
              var answer = d['answer'];
              var poster_name = d['poster_name'];
              var poster_account_type = d['poster_account_type'];
              var poster_account_uid = d['owner_uid'];
              answertiles.add(Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.blue, style: BorderStyle.solid)),
                  child: Column(
                    children: [
                      ListTile(
                        onLongPress: () {
                          showReportAnswerPopUp(poster_account_uid);
                        },
                        onTap: () {
                          if (poster_account_type == "teacher") {
                            openteacher(poster_account_uid);
                          }
                        },
                        trailing: IconButton(
                            icon: Icon(
                              Icons.thumb_up,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              if (this.uid != poster_account_uid) {
                                sendlikenotification(poster_account_uid);
                              }
                            }),

                        leading: poster_account_type == "teacher"
                            //if posted by a teacher:
                            ? Column(
                                children: [
                                  Icon(Icons.person, color: Colors.blue),
                                  GestureDetector(
                                    onTap: () {
                                      openteacher(poster_account_uid);
                                    },
                                    child: Text(
                                      "posted by: " + poster_name,
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ),
                                ],
                              )

                            //if posted by a student
                            : Text("posted by " + poster_name,
                                style: TextStyle(color: Colors.black54)),
                        //subtitle: Text(poster_name),
                      ),
                      Divider(),
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          answer,
                          style: descriptionstyle,
                        ),
                      )),
                    ],
                  ),
                ),
              ));
            }

            return ListView(
              children: answertiles,
            );
          }),
    );
  }

  Widget showReportAnswerPopUp(answerid) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.error,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  "You shall report if inappropriate content/ hate speech or any other violation of the Terms and Condtions is or are present",
                  style: TextStyle(color: Colors.black54),
                ),
                FlatButton(
                  onPressed: () {
                    sendreport(answerid);
                    CoolAlert.show(
                        context: context,
                        type: CoolAlertType.success,
                        text: "Thank you for reporting!");
                  },
                  child: Text(
                    "Report",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  sendreport(answerid) {
    Firestore.instance.collection("reports").document(answerid).setData(
        {"reported_by_uid": this.uid, "reported_by_username": this.username});
    Navigator.pop(context);
  }

  //Post Answer Pop up
  Widget showpopup() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * (60 / 100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: answertext,
                  maxLines: 5,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "type an answer.......",
                      labelText: "Answer"),
                ),
              ),
              RaisedButton.icon(
                onPressed: postanswer,
                icon: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                label:
                    Text("Post Answer", style: TextStyle(color: Colors.white)),
                color: Colors.blue,
              )
            ],
          ),
        );
      },
    );
  }

  Widget showanswerspopup() {
    showMaterialModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return answersstreambuilder();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.edit),
          onPressed: showpopup,
        ),
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.account_box),
                        title: Text(
                          "posted by " + widget.poster_username,
                          style: namestyle,
                        ),
                        onLongPress: () {
                          showReportAnswerPopUp(widget.question_id);
                        },
                        subtitle: Text(widget.title),
                      ),
                      Divider(),
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          widget.description,
                          style: descriptionstyle,
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ),
            RaisedButton.icon(
              onPressed: showanswerspopup,
              icon: Icon(
                Icons.chat_bubble,
                color: Colors.white,
              ),
              label: Text(
                "View answers",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
            ),
          ],
        ));
  }
}
