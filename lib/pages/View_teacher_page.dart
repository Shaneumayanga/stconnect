import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stconnect/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

class ViewTeacherPage extends StatefulWidget {
  final uid;
  final email;
  final username;
  final subjects;
  final phonenumber;
  final bio;

  ViewTeacherPage(
      {this.uid,
      this.email,
      this.username,
      this.phonenumber,
      this.subjects,
      this.bio});

  @override
  _ViewTeacherPageState createState() => _ViewTeacherPageState();
}

class _ViewTeacherPageState extends State<ViewTeacherPage> {
  List<Widget> subjectstext = [];

  @override
  void initState() {
    //c9f5440e-8bb4-4429-8af1-c2f87fb7d783

    // TODO: implement initState
    super.initState();

    FacebookAudienceNetwork.init();

    showad();

    for (var i = 0; i < widget.subjects.length; i++) {
      subjectstext.add(buildSubjectText(widget.subjects[i]));
    }
  }

  void showad() {
    if (!isapptesting) {
      FacebookInterstitialAd.loadInterstitialAd(
        placementId: "216703189834407_216709833167076",
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

  Widget buildSubjectText(String subject) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        alignment: Alignment.center,
        decoration: kBoxTeacherSubjectDeco,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              "$subject",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildbutton(
    IconData iconData,
    String title,
    onclick,
  ) {
    return Container(
      child: Container(
        alignment: Alignment.bottomRight,
        width: MediaQuery.of(context).size.width * (30 / 100),
        child: RaisedButton(
          onPressed: onclick,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Text(
                  '$title',
                  style: TextStyle(
                    color: Color(0xFF527DAA),
                    letterSpacing: 1.5,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
              Icon(
                iconData,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  showtimetablepopup() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * (70 / 100),
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection("timeTables")
                    .document(widget.uid)
                    .collection("timeTables")
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: Text("Loading..."));
                  }
                  var data;
                  data = snapshot.data.documents;
                  List<Widget> tiles = [];
                  for (var d in data) {
                    var subject = d['subject'];
                    var grade = d['grade'];
                    //date
                    var day = d['day'];
                    var month = d['month'];
                    var year = d['year'];
                    //time
                    var hour = d['hour'];
                    var minute = d['minute'];

                    Widget tile = ListTile(
                        leading: Icon(
                          Icons.info,
                          color: Colors.blue,
                        ),
                        title: Text("Class for ${subject}"),
                        subtitle: Text(
                            "On ${day}/${month}/${year} at ${hour}:${minute}"),
                        trailing: Text("${grade}"));

                    tiles.add(Column(
                      children: [
                        tile,
                        Container(
                          width: MediaQuery.of(context).size.width * (70 / 100),
                          child: Divider(
                            color: Colors.black54,
                          ),
                        )
                      ],
                    ));
                  }
                  return tiles.length == 0
                      ? Center(
                          child:
                              Text("No time tables available for this teacher"),
                        )
                      : ListView(
                          children: tiles,
                        );
                }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(8.0),
          height: MediaQuery.of(context).size.height * (8 / 100),
          child: buildbutton(
              Icons.table_chart, "View Time Tables", showtimetablepopup),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.lightBlue,
                      border: Border.all(color: Colors.blue)),
                  width: 100,
                  height: 100,
                  child: Center(
                      child: Text(
                    "${widget.username[0].toUpperCase()}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.0,
                        fontWeight: FontWeight.w400),
                  )),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "${widget.username}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    fontSize: 25.0,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: ListTile(
                    title: Text("Bio"),
                    subtitle: Text(widget.bio),
                  ),
                ),
              ),
              Divider(),
              Container(
                height: MediaQuery.of(context).size.height * (10 / 100),
                child: ListView(
                  children: subjectstext,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * (80 / 100),
                child: Divider(),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildbutton(
                      Icons.phone,
                      "Call",
                      () async {
                        var phonenumber = widget.phonenumber;
                        phonenumber = phonenumber.toString();
                        await launch("tel:$phonenumber");
                      },
                    ),
                    buildbutton(
                      Icons.email,
                      "Email",
                      () async {
                        var email = widget.email;
                        email = email.toString();
                        await launch("mailto:$email");
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
