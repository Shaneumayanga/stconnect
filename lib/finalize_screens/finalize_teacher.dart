import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';



class FinalizeTeacher extends StatefulWidget {
  final subs;
  final password;
  final username;
  final email;
  final phonenumber;
  final bio;
  


  FinalizeTeacher({
   this.subs,
   this.password,
   this.username,
   this.phonenumber,
   this.email,
   this.bio,
 
  
  });
  @override
  _FinalizeTeacherState createState() => _FinalizeTeacherState();
}

class _FinalizeTeacherState extends State<FinalizeTeacher> {

  bool iserror = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    register();
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      if(user!=null){
        String uid = user.uid;
        writetodatabase(uid);
        writetolocaldb();
        pause_and_go();
      }
    });
    print(widget.subs);
    print(widget.phonenumber);
    print(widget.username);
    print(widget.email);
    print(widget.password);


  }

  void register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: widget.email, password: widget.password);
    } catch (e) {
      CoolAlert.show(
          context: context, type: CoolAlertType.error, text: e.message);
      setState(() {
        iserror = true;
      });

    }
  }

  void writetodatabase(String uid) async{
    try{
      await Firestore.instance.collection("users").document(uid).setData({
        "username":widget.username,
        "account_type":"teacher",
        "subjects":widget.subs,
        "phonenumber":widget.phonenumber,
        "email":widget.email,
        "bio":widget.bio,
        
     
      });
    }catch (e){
      print(e.message);
    }
    try{
      await Firestore.instance.collection("teachers").document(uid).setData({
        "username":widget.username,
        "subjects":widget.subs,
        "phonenumber":widget.phonenumber,
        "email":widget.email,
        "uid": uid,
         "bio":widget.bio,
         
       
      });
    }catch (e){
      print(e.message);
    }
  }

  void writetolocaldb(){
    var box = Hive.box("account");
    box.put("username", widget.username);
    box.put("account_type", "teacher");
  }

  void pause_and_go(){
    Timer(Duration(seconds:3),(){
      Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
    });
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: iserror? Container( child: Center(
        child: RaisedButton(onPressed: (){Navigator.pop(context);}, child: Text("Retry"),),
      ),) : Center(
        child: TypewriterAnimatedTextKit(
          repeatForever: true,
          text:[
            "Creating account for ${widget.username}.....",
            "Account type : teacher",
            "Saving your data.....",
            "Creating account......"
          ],
          textStyle: TextStyle(
            color: Colors.blue
          ),
        ),
      ),
    );
  }
}
