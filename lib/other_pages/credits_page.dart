import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:stconnect/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsPage extends StatefulWidget {
  @override
  _CreditsPageState createState() => _CreditsPageState();
}

class _CreditsPageState extends State<CreditsPage> {
  TextStyle textStyle = TextStyle(color: Colors.white);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Credits"),
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                title: Column(
                  children: [
                    Text(
                      "Aivn Altair",
                      style: textStyle,
                    ),
                    Container(child: Divider(color: Colors.white))
                  ],
                ),
                trailing: Text(
                  "Graphic designer",
                  style: textStyle,
                ),
                subtitle: Column(
                  children: [
                    AutoSizeText(
                        "Icon, screenshots and related Graphics design",
                        style: textStyle),
                    Container(child: Divider(color: Colors.white)),
                    AutoSizeText("Follow on instagram", style: textStyle),
                  ],
                ),
                onTap: () {
                  launch("https://www.instagram.com/aivn_altair_official/");
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                title: Column(
                  children: [
                    Text(
                      "Pranavan V",
                      style: textStyle,
                    ),
                    Container(child: Divider(color: Colors.white))
                  ],
                ),
                trailing: Text(
                  "Writer",
                  style: textStyle,
                ),
                subtitle: Column(
                  children: [
                    AutoSizeText(
                        "Writer:- Description in Store listing , mission, vision",
                        style: textStyle),
                    Container(child: Divider(color: Colors.white)),
                    AutoSizeText("Follow on instagram", style: textStyle),
                  ],
                ),
                onTap: () {
                  launch("https://www.instagram.com/_pranawan.vp_/?igshid=w3qvqk45hlsq");
                },
              ),
            ),
          ),
               Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                title: Column(
                  children: [
                    Text(
                      "Eduspike.tk",
                      style: textStyle,
                    ),
                    Container(child: Divider(color: Colors.white))
                  ],
                ),
                trailing: Text(
                  "Past papers",
                  style: textStyle,
                ),
                subtitle: Column(
                  children: [
                    AutoSizeText(
                        "Past papers provider",
                        style: textStyle),
                    Container(child: Divider(color: Colors.white)),
                    AutoSizeText("Open website", style: textStyle),
                  ],
                ),
                onTap: () {
                  launch("eduspike.tk");
                },
              ),
            ),
          )
        ]));
  }
}
