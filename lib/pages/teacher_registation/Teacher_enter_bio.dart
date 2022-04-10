import 'dart:ui';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stconnect/pages/teacher_registation/Teacher_enter_details.dart';
import 'package:stconnect/utils/constants.dart';

class TeacherEnterBio extends StatefulWidget {
  final subs;
  TeacherEnterBio({
    this.subs,
  });
  @override
  _TeacherEnterBioState createState() => _TeacherEnterBioState();
}

class _TeacherEnterBioState extends State<TeacherEnterBio> {
  String skippedbio = "No bio";

  TextEditingController biotext = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.subs);
  }

  void continuereg() {
    if (biotext.text != "") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return TeacherEnterDetails(
          selectedsubs: widget.subs,
          bio: biotext.text,
        );
      }));
    } else {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: "Please enter a bio");
    }
  }

  void continueregwithbioskipped() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TeacherEnterDetails(
        selectedsubs: widget.subs,
        bio: this.skippedbio,
      );
    }));
  }

  Widget buildTF(
      TextEditingController controller,
      String title,
      String hinttext,
      IconData iconData,
      TextInputType inputType,
      bool obcure) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$title',
          style: kBioLabelStyle,
        ),
        Container(
          width: MediaQuery.of(context).size.width * (60 / 100),
          child: Divider(
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Color(0xFF6CA8F1),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            maxLines: 8,
            obscureText: obcure,
            controller: controller,
            keyboardType: inputType,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              hintText: '$hinttext',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF73AEF5),
                    Color(0xFF61A4F1),
                    Color(0xFF478DE0),
                    Color(0xFF398AE5),
                  ],
                  stops: [0.1, 0.4, 0.7, 0.9],
                )),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildTF(
                          biotext,
                          "Enter a bio",
                          "Eg :- English teacher from kandy",
                          Icons.account_box,
                          TextInputType.name,
                          false),
                      SizedBox(height: 13.0),
                      RaisedButton.icon(
                        onPressed: continuereg,
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Continue",
                          style: kLabelStyle,
                        ),
                        color: Colors.lightBlue,
                      ),
                      SizedBox(height: 13.0),
                      GestureDetector(
                        onTap: continueregwithbioskipped,
                        child: Container(
                          child: Text(
                            "Skip this Step",
                            style: TextStyle(color: Colors.white , fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
