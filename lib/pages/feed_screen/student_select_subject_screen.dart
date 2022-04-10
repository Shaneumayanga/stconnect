import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stconnect/pages/Main_page.dart';
import 'package:stconnect/utils/constants.dart';
import 'package:stconnect/utils/global_variables.dart';
import 'package:stconnect/widgets/selectedsubitem.dart';
import 'package:stconnect/widgets/subjectitem.dart';

class Select extends StatefulWidget {
  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> with AutomaticKeepAliveClientMixin {
  var box;

  @override
  initState() {
    super.initState();
    box = Hive.box("student_subjects");
  }

  List<String> subjects = ksubjects;

  List<String> selectedSubs = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () {
            box.put("subjects", this.selectedSubs);

            Timer(Duration(milliseconds: 700), () {
              Navigator.pop(context);

              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MainPage();
              }));
            });
          },
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF73AEF5),
                Color(0xFF61A4F1),
              ],
              stops: [0.1, 0.4],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Text(
                    "To get personal recommendations",
                    style: kLabelStyle,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedSubs.length,
                  itemBuilder: (context, index) {
                    return SelectedSubitem(
                      title: selectedSubs[index],
                      color: Colors.blueAccent,
                    );
                  },
                ),
              ),
              Container(
                child: Text(
                  "Select your subjects",
                  style: kLabelStyle,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    //item is the subject string
                    final item = subjects[index];
                    return Dismissible(
                      key: Key(item),
                      onDismissed: (direction) {
                        setState(() {
                          subjects.removeAt(index);
                          selectedSubs.add(item);
                        });
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text("$item Added")));
                      },
                      child: SubjectItem(
                        title: "$item",
                        color: Colors.blue,
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
