import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stconnect/main.dart';
import 'package:stconnect/pages/About_page.dart';
import 'package:stconnect/utils/constants.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var account_type;
  var username;
  var subjects;
  var phonenumber;
  var email;
  var bio;
  bool isteacher = false;
  String uid;

  TextEditingController usernametxtcontrol = TextEditingController();
  TextEditingController phonenumbertextcontrol = TextEditingController();
  TextEditingController emailtextcontrol = TextEditingController();
  TextEditingController biotextcontrol = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      if (user != null) {
        getuserfromfirestore(user.uid);
        uid = user.uid;
      }
    });
  }

  void getuserfromfirestore(String uid) async {
    await Firestore.instance
        .collection("users")
        .document(uid)
        .get()
        .then((data) {
      setState(() {
        username = data['username'];
        usernametxtcontrol.text = username;
        account_type = data['account_type'];
      });
      if (account_type == "teacher") {
        if(data['bio']=="No bio" || data['bio']==null){
          //Null for the poeple who had the old version of the app
          //No bio is for the people who has skipped the bio
         // CoolAlert.show(context: context, type: CoolAlertType.info , title:  " please enter a bio to be shown in your profile");
        }
        setState(() {
          subjects = data['subjects'];
          phonenumber = data['phonenumber'];
          phonenumbertextcontrol.text = phonenumber;
          email = data['email'];
          emailtextcontrol.text = email;
          bio = data['bio'];
          biotextcontrol.text = bio;
          isteacher = true;
        });
      }
    });
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
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
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
              prefixIcon: Icon(
                iconData,
                color: Colors.white,
              ),
              hintText: '$hinttext',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget accountcontrols() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
              child: RaisedButton(
            color: Colors.blue,
            textColor: Colors.white,
            onPressed:handleupdatedetails,
            child: Text("Update details"),
          )),
          Container(
              child: RaisedButton(
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: handlelogout,
            child: Text("Log out"),
          )),
        ],
      ),
    );
  }

  void handlelogout() {
    var account = Hive.box("account");
    account.delete("username");
    account.delete("account_type");
    FirebaseAuth.instance.signOut();
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MyApp();
    }));
  }

  void handleupdatedetails() async{
    if(this.isteacher){
      updateteacher();
    }else{
      //student details updated
      updatestudent();
    }
    updatelocaldb();
    CoolAlert.show(context: context, type: CoolAlertType.info, text: "Updated");
  }


  void updateteacher() async{
    try{
      await Firestore.instance.collection("users").document(uid).setData({
        "username":usernametxtcontrol.text,
        "account_type":"teacher",
        "subjects":this.subjects,
        "phonenumber":phonenumbertextcontrol.text,
        "email":emailtextcontrol.text,
        "bio":biotextcontrol.text,
      });
    }catch (e){
      print(e.message);
    }
    try{
      await Firestore.instance.collection("teachers").document(uid).setData({
        "username":usernametxtcontrol.text,
        "subjects":this.subjects,
        "phonenumber":phonenumbertextcontrol.text,
        "email":emailtextcontrol.text,
        "uid": uid,
        "bio":biotextcontrol.text,
      });
    }catch (e){
      print(e.message);
    }

  }

  void updatestudent() async{
    try{
      await Firestore.instance.collection("users").document(uid).setData({
        "username":usernametxtcontrol.text,
        "account_type":"student"
      });
    }catch (e){
      print(e.message);
    }
  }


  void updatelocaldb(){
    var account = Hive.box("account");
    account.put("username", "${usernametxtcontrol.text}");
  }





  Widget buildteachersettings() {
    return Container(
      child: Column(
        children: [
          buildTF(usernametxtcontrol, "Your username", "cannot be empty",
              Icons.account_box, TextInputType.name, false),
          buildTF(phonenumbertextcontrol, "Your phone number",
              "cannot be empty", Icons.account_box, TextInputType.name, false),
          buildTF(emailtextcontrol, "Your email", "cannot be empty",
              Icons.account_box, TextInputType.name, false),
          buildTF(biotextcontrol, "Your bio", "Eg :- I am an English teache from kandy",
              Icons.info, TextInputType.name, false),
          accountcontrols()
        ],
      ),
    );
  }

  Widget buildstudentsettings() {
    return Container(
        child: Column(children: [
      buildTF(usernametxtcontrol, "Your username", "cannot be empty",
          Icons.account_box, TextInputType.name, false),
      accountcontrols(),
    ]));
  }

  Widget getlandingpage() {
    return isteacher ? buildteachersettings() : buildstudentsettings();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: RaisedButton(
          color: Colors.blue,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return AboutPage();
            }));
          },
          child: Text("About Stconnect", style: TextStyle(
            color: Colors.white
          ),),
        ),
        body: getlandingpage(),
      ),
    );
  }
}
