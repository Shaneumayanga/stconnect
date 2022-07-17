import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:stconnect/pages/forum_tab/post_question_page.dart';
import 'package:stconnect/pages/forum_tab/read_question_page.dart';
import 'package:stconnect/utils/constants.dart';
import 'package:stconnect/utils/global_variables.dart';

class ForumTab extends StatefulWidget {
  @override
  _ForumTabState createState() => _ForumTabState();
}

class _ForumTabState extends State<ForumTab>
    with AutomaticKeepAliveClientMixin {
  List<String> subjects = [
    "All",
    "My Questions",
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
  String uid = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //default is "All"
    selectedsub = subjects[0];
    FirebaseAuth.instance.onAuthStateChanged.listen((event) {
      this.uid = event.uid;
    });
  }

  Widget buildQuestionTile(String title, String description,
      String poster_username, String subject, ontap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue,
            style: BorderStyle.solid,
          ),
        ),
        child: ListTile(
          onTap: ontap,
          leading: Icon(
            Icons.chat_bubble,
            color: Colors.blue,
          ),
          title: Text(
            title,
            style: TextStyle(color: Colors.blue),
          ),
          subtitle: Text(description),
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
        ),
      ),
    );
  }

  Widget buildstreambuilder() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("questions")
          .orderBy("datetime", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
        var data;
        data = snapshot.data.documents;
        int index = 0;

        List<Widget> cards = [];
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

          Widget tile = buildQuestionTile(
              title,
              shoulddescritionminimzed
                  ? descriptionminimized + " ..."
                  : description,
              poster_username,
              subject, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ReadQuestionPage(
                  title: title,
                  description: description,
                  poster_username: poster_username,
                  question_id: question_id,
                  subject: subject,
                  posted_question_owner_uid: posted_question_owner_uid);
            }));
          });

          if (this.selectedsub == this.subjects[0]) {
            if (index == 4) {
              cards.add(Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  color: Colors.blue,
                ),
              ));
            }
            cards.add(tile);
          }

          if (this.selectedsub == subject) {
            cards.add(tile);
          }
          if (this.selectedsub == this.subjects[1]) {
            if (posted_question_owner_uid == this.uid) {
              cards.add(tile);
            }
          }

          index++;
        }
        return Container(
          child: cards.length == 0
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      this.selectedsub == this.subjects[1]
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "You have not posted any questions yet , don't hesitate to ask! \n Feel free to ask questions in any Language(Sinhala , Tamil , English) ",
                                  style: TextStyle(color: Colors.black54)),
                            )
                          : Text(
                              "No questions found for ${this.selectedsub} :-(",
                              style: TextStyle(color: Colors.black54),
                            ),
                      Container(
                          width: MediaQuery.of(context).size.width * (50 / 100),
                          child: Divider()),
                    ],
                  ),
                )
              : ListView(
                  children: cards,
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return PostQuestion();
          }));
        },
        label: Text("Ask a question"),
      ),
      body: buildstreambuilder(),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
