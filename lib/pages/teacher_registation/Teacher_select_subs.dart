import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stconnect/pages/teacher_registation/Teacher_enter_bio.dart';
import 'package:stconnect/utils/constants.dart';
import 'package:stconnect/utils/global_variables.dart';
import 'package:stconnect/widgets/selectedsubitem.dart';
import 'package:stconnect/widgets/subjectitem.dart';

import 'Teacher_enter_details.dart';

class TeacherSelectSubs extends StatefulWidget {
  @override
  _TeacherSelectSubsState createState() => _TeacherSelectSubsState();
}

class _TeacherSelectSubsState extends State<TeacherSelectSubs> {
  List<String> subjects = ksubjects;

  List<String> selectedSubs = [];

  Widget buildTF(TextEditingController controller, String title,
      String hinttext, IconData iconData, TextInputType inputType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$title',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: (){
        
          if(selectedSubs.length >=1){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return TeacherEnterBio(
                subs: this.selectedSubs,
              );
            }));
          }else{
            CoolAlert.show(context: context, type: CoolAlertType.info , text: "Please select more than one subject ");
          }

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
           
            // colors: [
            //  Color(0xFFFFFFFF),
            //  Color(0xFFFFFFFF),
            //  ],
            stops: [0.1, 0.4],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                "Select the subjects you teach",
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
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text("$item Added")));
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
    );
  }
}
