import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stconnect/pages/View_teacher_page.dart';
import 'package:stconnect/utils/constants.dart';
import 'package:stconnect/utils/global_variables.dart';

class TeachersTabPageMain extends StatefulWidget {
  @override
  _TeacherTabPageMainState createState() => _TeacherTabPageMainState();
}

class _TeacherTabPageMainState extends State<TeachersTabPageMain>
    with AutomaticKeepAliveClientMixin {
  List<String> subjects = ksubjects_teacher_tab;
  var selectedsub;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //default is "All"
    selectedsub = subjects[0];
  }

  Widget buildTeachersSection() {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //Text("Filter Subject  "),
              Container(
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
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
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
              ),
            ],
          ),
        ),
        body: Container(
            child: StreamBuilder(
          stream: Firestore.instance.collection("teachers").snapshots(),
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
              for (var i = 0; i < subjects.length; i++) {
                var current = subjects[i];
                if (this.selectedsub == current) {
                  teachercards.add(card);
                }
              }

              if (this.selectedsub == this.subjects[0]) {
                teachercards.add(card);
              }
            }
            if (teachercards.length == 0) {
              noteachers = true;
            }
            return noteachers
                ? Center(
                    child: Text(
                      "No teachers found for this subject :-(",
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                : ListView(
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

  Widget buildteachercard(String teachername, List subjects, onclick) {
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
