import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'forum_tab/read_question_page.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late String uid;

  @override
  initState() {
    super.initState();
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      setState(() {
        uid = user.uid;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    deleteNotifications();
  }

  void deleteNotifications() async {
    await Firestore.instance
        .collection('notifications')
        .document(this.uid)
        .collection("notifications")
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });
  }

  Widget getnotificationstream() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("notifications")
          .document(this.uid)
          .collection("notifications")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: Text("Loading..."));
        }
        var data = snapshot.data.documents;
        List<Widget> notificationtiles = [];
        for (var d in data) {
          var notificationtype = d['type'];
          //Null is for old users , question_answer is for new users , same thing
          //answer quesion notification
          if (notificationtype == null || notificationtype == "posted_answer") {
            notificationtiles.add(Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blue)),
                child: ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('New Answer to your question'),
                    subtitle: Text("\"" + d['question_title'] + "\""),
                    trailing: Text("by " + d['username'],
                        style: TextStyle(color: Colors.black54)),
                    onTap: () async {
                      var questionid = d['question_id'];
                      Firestore.instance
                          .collection("questions")
                          .document(questionid)
                          .get()
                          .then((doc) {
                        var title = doc['title'];
                        var description = doc['description'];
                        var poster_username = doc['poster_usrename'];
                        var question_id = doc['question_id'];
                        var subject = doc['subject'];
                        var posted_question_owner_uid = doc['owner_uid'];
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ReadQuestionPage(
                              title: title,
                              description: description,
                              poster_username: poster_username,
                              question_id: question_id,
                              subject: subject,
                              posted_question_owner_uid:
                                  posted_question_owner_uid);
                        }));
                      });
                    }),
              ),
            ));
          }
          //answer notification end

          //Like notification start
          if (notificationtype == "answerlike") {
            var liked_by_name = d['liked_by_name'];
            var liked_question = d['question'];

            notificationtiles.add(Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blue)),
                child: ListTile(
                  leading: Icon(
                    Icons.thumb_up,
                    color: Colors.blue,
                  ),
                  title: Text(
                    "$liked_by_name Liked your answer to the question $liked_question",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
            ));
          }
        }
        return notificationtiles.length == 0
            ? Center(
                child: Text(
                  "No new notifications",
                  style: TextStyle(color: Colors.black54),
                ),
              )
            : ListView(
                children: notificationtiles,
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: Container(
        child: getnotificationstream(),
      ),
    );
  }
}
