import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stconnect/utils/constants.dart';
import 'package:uuid/uuid.dart';
import 'package:cool_alert/cool_alert.dart';

class TeacherAddTimeTable extends StatefulWidget {
  @override
  _TeacherAddTimeTableState createState() => _TeacherAddTimeTableState();
}

class _TeacherAddTimeTableState extends State<TeacherAddTimeTable> {
  final kboxdropdown = BoxDecoration(
    color: Colors.blue,
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  final tiledeco = BoxDecoration(
      border: Border.all(
    color: Colors.blue,
  ));
  late DateTime pickeddate;
  late TimeOfDay time;
  bool isloading = true;
  List<String> subjects = ['Loading'];
  var selectedsub;
  List<String> grades = ["Grade 1-5", "Grade 6-9", "O/L", "A/L"];
  var selectedgrade;
  late String uid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pickeddate = DateTime.now();
    time = TimeOfDay.now();
    selectedgrade = grades[0];
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      if (user != null) {
        setState(() {
          this.uid = user.uid;
        });
        getsubjectsFromFirestore(user.uid);
      }
    });
  }

  void getsubjectsFromFirestore(String useruid) async {
    try {
      var data = await Firestore.instance
          .collection("teachers")
          .document(useruid)
          .get();

      var subs = data.data['subjects'];
      this.subjects = [];
      for (var i = 0; i < subs.length; i++) {
        this.subjects.add(subs[i]);
      }
      setState(() {
        this.isloading = false;
        this.selectedsub = this.subjects[0];
      });
    } catch (e) {
      print("error");
      CoolAlert.show(
          context: context, type: CoolAlertType.error, title: e.toString());
    }
  }

  void _picdate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: this.pickeddate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (date != null) {
      setState(() {
        this.pickeddate = date;
      });
    }
  }

  void _pickTime() async {
    TimeOfDay? t = await showTimePicker(context: context, initialTime: time);
    if (t != null)
      setState(() {
        time = t;
      });
  }

  void addTimeTabletoFireStore() async {
    if (this.subjects[0] != "Loading") {
      print(this.selectedsub);
      print(this.selectedgrade);
      print(this.time.hour);
      print(this.time.minute);
      print(this.pickeddate);
      await Firestore.instance
          .collection("timeTables")
          .document(this.uid)
          .collection("timeTables")
          .document(Uuid().v4())
          .setData({
        "subject": this.selectedsub,
        "grade": this.selectedgrade,
        "day": this.pickeddate.day,
        "month": this.pickeddate.month,
        "year": this.pickeddate.year,
        "hour": this.time.hour,
        "minute": this.time.minute
      });
      showtimetablepopup();
      CoolAlert.show(
          context: context,
          type: CoolAlertType.info,
          title: "Time table added");
    }
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
                    .document(this.uid)
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

                  tiles.add(ListTile(
                      leading: Icon(Icons.table_chart),
                      title: Text(
                        "These are your current time tables",
                        style: TextStyle(color: Colors.black54),
                      ),
                      subtitle: Text("Long press to Delete")));
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
                      trailing: Text("${grade}"),
                      onLongPress: () async {
                        print(d);
                        await Firestore.instance
                            .collection("timeTables")
                            .document(this.uid)
                            .collection("timeTables")
                            .document(d.reference.documentID)
                            .delete();
                      },
                    );

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
    return Scaffold(
      bottomNavigationBar: this.isloading
          ? Container()
          : Container(
              height: MediaQuery.of(context).size.height * (5 / 100),
              child: RaisedButton(
                onPressed: showtimetablepopup,
                child: Text("View your Time tables",
                    style: TextStyle(color: Colors.white)),
                color: Colors.blue,
              ),
            ),
      appBar: AppBar(
        title: Text("Add a Time table"),
      ),
      body: this.isloading
          ? Center(
              child: Text("Loading...."),
            )
          : Container(
              child: ListView(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                      child: Text(
                    "Select a date",
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w500),
                  )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: tiledeco,
                      child: ListTile(
                        title: Text(
                            "Date: ${this.pickeddate.year}/${pickeddate.month}/${this.pickeddate.day}"),
                        trailing: Icon(Icons.keyboard_arrow_down),
                        subtitle: Text("Tap to select a date"),
                        onTap: _picdate,
                      ),
                    ),
                  ),
                  Center(
                      child: Text(
                    "Select a time",
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w500),
                  )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: tiledeco,
                      child: ListTile(
                        title: Text("Time: ${time.hour}:${time.minute}"),
                        trailing: Icon(Icons.keyboard_arrow_down),
                        subtitle: Text("Tab to select a time"),
                        onTap: _pickTime,
                      ),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: kboxdropdown,
                      width: double.infinity,
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
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
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
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: kboxdropdown,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton<String>(
                          value: selectedgrade,
                          dropdownColor: Colors.blue,
                          items: grades.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              this.selectedgrade = val;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton.icon(
                        color: Colors.blue,
                        onPressed: addTimeTabletoFireStore,
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Add",
                          style: TextStyle(color: Colors.white),
                        )),
                  )
                ],
              ),
            ),
    );
  }
}
