import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:stconnect/pages/passpaper_tab/readpaper_page.dart';
import 'package:stconnect/utils/constants.dart';

class PassPapersTabPage extends StatefulWidget {
  @override
  _PassPapersTabPageState createState() => _PassPapersTabPageState();
}

class _PassPapersTabPageState extends State<PassPapersTabPage> {
  String searchterm = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget buildsubjecttile(subject, links, onTap) {
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
                  Text("Past papers", style: TextStyle(color: Colors.white54)),
            ),
            Container(
              width: MediaQuery.of(context).size.width * (90 / 100),
              child: Divider(
                color: Colors.white,
              ),
            ),
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
                "Open",
                style: TextStyle(color: Color(0xFF527DAA)),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (e) {
                  print(e);
                  setState(() {
                    this.searchterm = e;
                  });
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Search for subjects"),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: DefaultAssetBundle.of(context)
                    .loadString("assets/passpapers.json"),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text("Loading...."),
                    );
                  }
                  final jsonResult = json.decode("[" + snapshot.data + "]");
                  List<Widget> subjecttile = [];

                  jsonResult[0].keys.forEach((key) {
                    List links = [];
                    var subject = key;
                    jsonResult[0][subject]['Past Papers'].keys.forEach((key) {
                      var yearandtitle = key;
                      var link =
                          jsonResult[0][subject]['Past Papers'][yearandtitle];
                      links.add(link);
                    });

                    Widget subtile = buildsubjecttile(subject, links, () {
                      print(links);
                      print(subject);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ReadPaperPage(
                          links: links,
                          subjectname: subject,
                        );
                      }));
                    });
                    if (this.searchterm == "") {
                      subjecttile.add(subtile);
                    }
                    String firstletter = subject[0];
                    String remaining = subject.substring(1, subject.length);
                    String subjectwithfirstlettercaps =
                        firstletter.toUpperCase() + remaining;
                    if (this.searchterm != "") {
                      if (subject.toString().trim().contains(this.searchterm) ||
                          subjectwithfirstlettercaps
                              .trim()
                              .contains(this.searchterm)) {
                        subjecttile.add(subtile);
                      }
                    }
                  });
                  return ListView(
                    children: subjecttile,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
