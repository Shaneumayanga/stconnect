import 'package:flutter/material.dart';

class SubjectItem extends StatelessWidget {
  final Color color;
  final String title;
  SubjectItem({this.color, this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Material(
              color: this.color,
              elevation: 5.0,
              borderRadius: BorderRadius.circular(30.0),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width * (70 / 100),
                onPressed:(){},
                child: Center(
                    child: Text(
                      "${this.title}",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    )),
              ),
            ),
          ),
          Expanded(child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("Swip to add",style: TextStyle(color: Colors.white),),
              Icon(Icons.arrow_right,color: Colors.white,),
            ],
          )),
        ],
      ),
    );
  }
}