import 'package:flutter/material.dart';

class SelectedSubitem extends StatelessWidget {
  final Color color;
  final String title;
  SelectedSubitem({required this.color, required this.title});
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
                onPressed: () {},
                child: Center(
                    child: Text(
                  "${this.title}",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
