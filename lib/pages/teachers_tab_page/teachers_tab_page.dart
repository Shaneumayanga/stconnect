import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stconnect/pages/View_teacher_page.dart';
import 'package:stconnect/pages/teachers_tab_page/teacher_tab_page_main.dart';
import 'package:stconnect/utils/constants.dart';
import 'package:stconnect/utils/global_variables.dart';

class TeachersTab extends StatefulWidget {
  @override
  _TeachersTabState createState() => _TeachersTabState();
}

class _TeachersTabState extends State<TeachersTab> {
  late Color buttonColor;
  @override
  void initState() {
    super.initState();
    setState(() {
      buttonColor = Colors.transparent;
    });
  }

  Widget buildTeachersSection() {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            child: StreamBuilder(
          stream:
              Firestore.instance.collection("teachers").limit(3).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            var noteachers = false;
            if (!snapshot.hasData) {
              return Center(child: Text("Loading..."));
            }
            var data;
            data = snapshot.data.documents;
            //builder function
            List<Widget> teachercards = [];
            for (var d in data) {
              var uid = d['uid'];
              var phonenumber = d['phonenumber'];
              var username = d['username'];
              var email = d['email'];
              var subjects = d['subjects'];
              var bio = d['bio'];
              //print(d['bio']);
              var card = buildteachercard(username, subjects, () {
                //View button onclick
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ViewTeacherPage(
                    username: username,
                    phonenumber: phonenumber,
                    uid: uid,
                    email: email,
                    subjects: subjects,
                    bio: bio == null ? "No bio" : d['bio'],
                  );
                }));
              });
              teachercards.add(card);
            }

            teachercards.add(AnimatedContainer(
              curve: Curves.easeIn,
              duration: Duration(milliseconds: 500),
              margin: EdgeInsets.all(3),
              decoration: BoxDecoration(
                border: Border.all(color: this.buttonColor, width: 1.0),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    color: Colors.blue,
                    onPressed: () {
                      setState(() {
                        this.buttonColor = Colors.blue;
                      });
                      Timer(Duration(milliseconds: 500), () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return TeachersTabPageMain();
                        }));
                      });
                    },
                    icon: Icon(Icons.person, color: Colors.white),
                    label: Text(
                      "Look for more teachers",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ));
            teachercards.add(SizedBox(
              height: 20,
            ));
            return ListView(
              children: teachercards,
            );
          },
        )),
      ),
    );
  }

  //subject oval
  Widget buildSubjectText(String subject) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Container(
        decoration: kBoxTeacherSubjectDeco,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AutoSizeText(
            "$subject",
            maxLines: 2,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  buildteachercard(String teachername, List subjects, onclick) {
    List<Widget> subjectstext = [];
    //subject ovals are made according to the subject List given to the parameter "subjects"
    for (var i = 0; i < subjects.length; i++) {
      subjectstext.add(buildSubjectText(subjects[i]));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: kBoxTeacherCardDecorationStyle,
        width: double.infinity,
        height: MediaQuery.of(context).size.height * (20 / 100),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "$teachername",
                style: kteachernameTextStyle,
              ),
            ),
            //subject ovals are shown in a List
            Container(
              child: Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: subjectstext,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * (90 / 100),
              child: Divider(
                color: Colors.white,
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              width: MediaQuery.of(context).size.width * (30 / 100),
              child: RaisedButton(
                onPressed: onclick,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: Colors.white,
                child: Text(
                  'View',
                  style: TextStyle(
                    color: Color(0xFF527DAA),
                    letterSpacing: 1.5,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildTeachersSection();
  }
}
