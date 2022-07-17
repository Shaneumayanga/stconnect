import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stconnect/pages/View_teacher_page.dart';

class AnswerTile extends StatefulWidget {
  final answer;
  final poster_name;
  final poster_account_type;
  final poster_account_uid;
  AnswerTile(
      {this.answer,
      this.poster_name,
      this.poster_account_type,
      this.poster_account_uid});
  @override
  _AnswerTileState createState() => _AnswerTileState();
}

class _AnswerTileState extends State<AnswerTile> {
//not used
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: Icon(Icons.edit, color: Colors.blue),
        title: Bubble(
          margin: BubbleEdges.only(top: 10),
          nip: BubbleNip.rightBottom,
          color: Colors.white54,
          child: Text('${widget.answer}',
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: Colors.black54, fontWeight: FontWeight.w700)),
        ),
        trailing: widget.poster_account_type == "teacher"
            ? Column(
                children: [
                  Icon(Icons.person, color: Colors.blue),
                  GestureDetector(
                    onTap: () async {
                      await Firestore.instance
                          .collection("teachers")
                          .document(widget.poster_account_uid)
                          .get()
                          .then((documentsnapshot) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ViewTeacherPage(
                            username: documentsnapshot['username'],
                            phonenumber: documentsnapshot['phonenumber'],
                            uid: documentsnapshot['uid'],
                            email: documentsnapshot['email'],
                            subjects: documentsnapshot['subjects'],
                            bio: documentsnapshot['bio'] == null
                                ? "No bio"
                                : documentsnapshot['bio'],
                          );
                        }));
                      });
                    },
                    child: Text(
                      widget.poster_name,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ],
              )
            : Text(widget.poster_name, style: TextStyle(color: Colors.black54)),
      ),
    );
  }
}
