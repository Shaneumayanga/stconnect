import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stconnect/pages/passpaper_tab/view_paper_page.dart';
import 'package:stconnect/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ReadPaperPage extends StatefulWidget {
  final subjectname;
  final links;
  ReadPaperPage({this.subjectname, this.links});

  @override
  _ReadPaperPageState createState() => _ReadPaperPageState();
}

class _ReadPaperPageState extends State<ReadPaperPage> {
  List<Widget> papertitles = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    papertitles.add(SizedBox(
      height: 15,
    ));
    for (var data in widget.links) {
      var link = data['link'];
      var description = data['description'];
      //view button on press
      this.papertitles.add(buildsubjecttile(description, link, () {
            print(link);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ViewPaperPage(link);
            }));
          }));
    }
  }

  Widget buildsubjecttile(subject, link, onTap) {
    String firstletter = subject[0];
    String remaining = subject.substring(1, subject.length);
    subject = firstletter.toUpperCase() + remaining;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          // color:Color(0xFF398AE5),
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10.0),

          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.book,
                color: Colors.white,
              ),
              title: Text(
                "${subject}",
                style: kteachernameTextStyle,
              ),
              subtitle:
                  Text("Past paper", style: TextStyle(color: Colors.white54)),
            ),
            Container(
              child: Divider(
                color: Colors.white,
              ),
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                RaisedButton.icon(
                  color: Colors.white,
                  icon: Icon(
                    Icons.open_in_new,
                    color: Colors.blue,
                  ),
                  onPressed: onTap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  label: Text(
                    "View",
                    style: TextStyle(color: Color(0xFF527DAA)),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                RaisedButton.icon(
                  color: Colors.white,
                  icon: Icon(
                    Icons.cloud_download,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    print(link);
                    launch(link);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  label: Text(
                    "Download",
                    style: TextStyle(color: Color(0xFF527DAA)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: this.papertitles,
        ),
      ),
    );
  }
}
