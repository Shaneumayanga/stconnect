import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:stconnect/pages/Settings_page.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:stconnect/pages/feed_screen/feed_screen.dart';
import 'package:stconnect/pages/notifications_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stconnect/pages/forum_tab/forum_tab.dart';
import 'package:stconnect/pages/passpaper_tab/passpaper_tab_page.dart';
import 'package:stconnect/pages/teacher_time_table_functions/teacher_add_timetable.dart';

import 'package:stconnect/pages/teachers_tab_page/teachers_tab_page.dart';
import 'package:stconnect/utils/constants.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var username = "...";
  var account_type = "...";

  late int currentIndex;
  late PageController pageController;

  //ad related
  bool hasnotifications = false;
  late String uid;
  bool isteacher = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Get account data from hive for account tab

    FacebookAudienceNetwork.init();
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      if (user != null) {
        getNotifications(user.uid);
      }
    });
    getaccountdata();
    currentIndex = 0;
    pageController = PageController();
    showad();
  }

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
          if (account_type == "teacher") {
            this.isteacher = true;
          }
        });
      }
    });
  }

  void getNotifications(uid) async {
    await Firestore.instance
        .collection("notifications")
        .document(uid)
        .collection("notifications")
        .limit(1)
        .getDocuments()
        .then(
          (doc) => {
            print(doc.documents.length),
            print(doc.documents),
            if (doc.documents.length != 0)
              {
                setState(() {
                  this.hasnotifications = true;
                }),
                CoolAlert.show(
                    context: context,
                    type: CoolAlertType.info,
                    title: "You have new notification(s)")
              }
          },
        );
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
    pageController.jumpToPage(index);
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

  Widget buildAddTimetablebutton() {
    return this.isteacher
        ? RaisedButton.icon(
            color: Colors.blue,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return TeacherAddTimeTable();
              }));
            },
            icon: Icon(
              Icons.table_chart,
              color: Colors.white,
            ),
            label: Text(
              "Add time table",
              style: TextStyle(color: Colors.white),
            ))
        : Container();
  }

  Widget buildaccountsection() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Username first letter ball
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
                "${username[0].toUpperCase()}",
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
              "${username}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                fontSize: 25.0,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
          Divider(),
          //settings button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SettingsPage();
                    }));
                  }),
              IconButton(
                  icon: hasnotifications
                      ? Icon(
                          Icons.notifications_active,
                          color: Colors.redAccent,
                        )
                      : Icon(Icons.notifications),
                  onPressed: () {
                    setState(() {
                      this.hasnotifications = false;
                    });
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Notifications();
                    }));
                  }),
            ],
          ),
          Divider(),
          buildAddTimetablebutton()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          FeedScreen(),
          ForumTab(),
          TeachersTab(),
          // PassPapersTabPage(),
          buildaccountsection(),
        ],
        controller: pageController,
        onPageChanged: changePage,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        initialSelection: 0,
        onTabChangedListener: changePage,
        tabs: [
          TabData(
            iconData: Icons.home,
            title: "Home",
          ),
          TabData(
            iconData: Icons.question_answer,
            title: "Discuss",
          ),
          TabData(
            iconData: Icons.person,
            title: "Teachers",
          ),
          //TabData(
          //iconData: Icons.book,
          // title: "past papers",
          // ),
          TabData(
            iconData: Icons.account_box,
            title: "Profile",
          ),
        ],
      ),
    );
  }
}
