import 'package:flutter/material.dart';
import 'package:stconnect/other_pages/credits_page.dart';
import 'package:stconnect/other_pages/disclaimer_page.dart';
import 'package:stconnect/other_pages/privacy_policy_page.dart';
import 'package:stconnect/other_pages/terms_and_conditions_page.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Terms and Conditions"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return TermsAndConditionsPage();
                }));
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Privacy policy"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return PrivacyPolicyPage();
                }));
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Disclaimer"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return DisclaimerPage();
                }));
              },
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text("Developer : Shane Umayanga"),
              subtitle: Text("Click to follow me on Instagram"),
              onTap: (){
                launch("https://www.instagram.com/shane_umayanga");
              },
            ),
            ListTile(
              leading: Icon(Icons.adb),
              title: Text("version : 2.5"),
              subtitle: Text("This is just the beginning , more to come!"),
            ),
             ListTile(
              leading: Icon(Icons.info_outline_sharp),
              title: Text("Credits"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                    return CreditsPage();
                }));
              },
            )
          ],
        ),
      ),
    );
  }
}
