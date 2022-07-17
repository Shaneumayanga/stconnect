import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:hive/hive.dart';
import 'package:stconnect/pages/feed_screen/student_select_subject_screen.dart';
import 'package:stconnect/pages/forum_tab/read_question_page.dart';

/**
 * isloading is a common variable used in both teacher and student view
 * 
 * in teacher getTeacherSubjectsFromFireStore() sets in isloading variable to false
 * 
 */

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with AutomaticKeepAliveClientMixin {
  var username = "...";
  var account_type;
  bool isteacher = false;

  bool isloading = true;

  String uid = "";
  var subjects = [];
  List<String> welcomenotes = ["Hi", "Hey", "Hello"];
  @override
  initState() {
    super.initState();
    getaccountdata();
  }

  void getaccountdata() {
    Timer(Duration(seconds: 2), () {
      var box = Hive.box("account");
      if (box != null) {
        var username = box.get("username");
        var account_type = box.get("account_type");
        print(account_type);
        if (account_type == "teacher") {
          FirebaseAuth.instance.onAuthStateChanged.listen((user) {
            if (user != null) {
              getTeacherSubjectsFromFireStore(user.uid);
            }
          });
        } else {
          check_if_student_has_subjects_in_Hive_db();
        }
        setState(() {
          this.username = username;
          this.account_type = account_type;
          if (account_type == "teacher") {
            this.isteacher = true;
          }
        });
      }
    });
  }

//Teacher related:
  void getTeacherSubjectsFromFireStore(String uid) async {
    await Firestore.instance
        .collection("teachers")
        .document(uid)
        .get()
        .then((data) {
      var subjects = data['subjects'];
      setState(() {
        this.subjects = subjects;
        this.isloading = false;
      });
    });
  }

  Widget prepairRecommendationsForTeacher() {
    Random rnd = new Random();
    var randomsubject = subjects[rnd.nextInt(subjects.length)];
    print(randomsubject);

    return StreamBuilder(
      stream: Firestore.instance
          .collection("questions")
          .where("subject", isEqualTo: randomsubject)
          .orderBy("datetime", descending: true)
          .limit(5)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        List<Widget> recommendationTiles = [];
        if (!snapshot.hasData) {
          return ListView(
            children: [
              ListTileShimmer(),
              ListTileShimmer(),
              ListTileShimmer(),
              ListTileShimmer(),
              ListTileShimmer(),
              ListTileShimmer(),
              ListTileShimmer(),
            ],
          );
        }
        var data = snapshot.data.documents;
        for (var d in data) {
          var descriptionminimized = "";
          var shoulddescritionminimzed = false;
          var title = d['title'];
          var description = d['description'];
          if (description.length > 20) {
            shoulddescritionminimzed = true;
            for (var i = 0; i < 17; i++) {
              descriptionminimized += description[i];
            }
          }
          var poster_username = d['poster_usrename'];
          var question_id = d['question_id'];
          var subject = d['subject'];
          var posted_question_owner_uid = d['owner_uid'];

          recommendationTiles.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    style: BorderStyle.solid,
                  ),
                ),
                child: ListTile(
                  title: Text(title),
                  leading: Icon(
                    Icons.question_answer,
                    color: Colors.blue,
                  ),
                  trailing: Column(
                    children: [
                      Text(
                        "by: " + poster_username,
                        style: TextStyle(color: Colors.blue),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Subject: " + subject,
                          style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                  subtitle: Text(shoulddescritionminimzed
                      ? descriptionminimized + "....."
                      : description),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ReadQuestionPage(
                          title: title,
                          description: description,
                          poster_username: poster_username,
                          question_id: question_id,
                          subject: subject,
                          posted_question_owner_uid: posted_question_owner_uid);
                    }));
                  },
                ),
              ),
            ),
          );
        }

        return recommendationTiles.length == 0
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sorry",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "There are no recommendations for you at the moment ",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        "Check back soon in moment",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              )
            : ListView(
                children: recommendationTiles,
              );
      },
    );
  }

  Widget teacherFeed() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
        Text(
          "Recommended for you",
          style: TextStyle(
              color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width * (20 / 100),
          child: Divider(
            color: Colors.blue,
          ),
        ),
        Text(
          "Questions that you might be able to answer",
          style: TextStyle(
              color: Colors.blue, fontSize: 12, fontWeight: FontWeight.w300),
        ),
        Expanded(
          flex: 4,
          child: prepairRecommendationsForTeacher(),
        ),
        Container(
          width: double.infinity,
        )
      ],
    );
  }

  //Teacher related End

  //Student Related:

  void check_if_student_has_subjects_in_Hive_db() {
    Timer(Duration(seconds: 2), () {
      var box = Hive.box("student_subjects");
      if (box != null) {
        if (box.get("subjects") == null) {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Select();
          }));
        } else {
          setState(() {
            this.isloading = false;
          });
        }
      }
    });
  }

  Widget buildStudentRecommendatsionstudentFeed() {
    var box = Hive.box("student_subjects");

    Random rnd = new Random();
    var subjects = box.get("subjects");
    var randomsubject = subjects[rnd.nextInt(subjects.length)];
    print(randomsubject);

    return StreamBuilder(
      stream: Firestore.instance
          .collection("questions")
          .where("subject", isEqualTo: randomsubject)
          .orderBy("datetime", descending: true)
          .limit(5)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        List<Widget> recommendationTiles = [];

        if (!snapshot.hasData) {
          return ListView(
            children: [
              ListTileShimmer(),
              ListTileShimmer(),
              ListTileShimmer(),
              ListTileShimmer(),
              ListTileShimmer(),
              ListTileShimmer(),
              ListTileShimmer(),
            ],
          );
        }
        var data = snapshot.data.documents;
        for (var d in data) {
          var descriptionminimized = "";
          var shoulddescritionminimzed = false;
          var title = d['title'];
          var description = d['description'];
          if (description.length > 20) {
            shoulddescritionminimzed = true;
            for (var i = 0; i < 17; i++) {
              descriptionminimized += description[i];
            }
          }
          var poster_username = d['poster_usrename'];
          var question_id = d['question_id'];
          var subject = d['subject'];
          var posted_question_owner_uid = d['owner_uid'];

          recommendationTiles.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    style: BorderStyle.solid,
                  ),
                ),
                child: ListTile(
                  title: Text(title),
                  leading: Icon(
                    Icons.question_answer,
                    color: Colors.blue,
                  ),
                  trailing: Column(
                    children: [
                      Text(
                        "by: " + poster_username,
                        style: TextStyle(color: Colors.blue),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Subject: " + subject,
                          style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                  subtitle: Text(shoulddescritionminimzed
                      ? descriptionminimized + "....."
                      : description),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ReadQuestionPage(
                          title: title,
                          description: description,
                          poster_username: poster_username,
                          question_id: question_id,
                          subject: subject,
                          posted_question_owner_uid: posted_question_owner_uid);
                    }));
                  },
                ),
              ),
            ),
          );
        }

        return recommendationTiles.length == 0
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sorry",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "There are no recommendations for you at the moment ",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        "Check back soon in moment",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              )
            : ListView(
                children: recommendationTiles,
              );
      },
    );
  }

  Widget studentFeed() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
        Text(
          "Recommended for you",
          style: TextStyle(
              color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width * (20 / 100),
          child: Divider(
            color: Colors.blue,
          ),
        ),
        Text(
          "Questions that you might find helpful",
          style: TextStyle(
              color: Colors.blue, fontSize: 12, fontWeight: FontWeight.w300),
        ),
        Expanded(
          flex: 4,
          child: buildStudentRecommendatsionstudentFeed(),
        ),
        Container(
          width: double.infinity,
        )
      ],
    );
  }

  //Student Related End

  Widget buildMainFeedScreen() {
    return this.isteacher ? teacherFeed() : studentFeed();
  }

  Widget loader() {
    return Container(
      width: double.infinity,
      alignment: Alignment.bottomCenter,
      child: LinearProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(50))),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.blueAccent,
            expandedHeight: 150,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${this.welcomenotes[Random().nextInt(this.welcomenotes.length)]} ${this.username}!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  "Hope you are having a great day!",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          SliverFillRemaining(
              child: this.isloading ? loader() : buildMainFeedScreen()),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
