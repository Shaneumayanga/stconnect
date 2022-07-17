import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stconnect/other_pages/terms_and_conditions_page.dart';
import 'package:stconnect/pages/teacher_registation/Teacher_select_subs.dart';

import 'Student_registration.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool is_agreed_to_termsandconditions = false;
  //StudentRegistration
  Widget _buildbutton(String text, onpress) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: this.is_agreed_to_termsandconditions
            ? onpress
            : () {
                CoolAlert.show(
                    context: context,
                    type: CoolAlertType.info,
                    title: "Please agree to the Terms and Conditions");
              },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.blue,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _agreementbutton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TermsAndConditionsPage();
            }));
          },
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'I agree to the ',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: 'Terms and Conditions',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Checkbox(
            value: is_agreed_to_termsandconditions,
            onChanged: (val) {
              setState(() {
                this.is_agreed_to_termsandconditions = val!;
              });
            }),
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
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white,
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 40.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("images/logo.jpg"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RotateAnimatedTextKit(
                              textAlign: TextAlign.start,
                              repeatForever: true,
                              text: ["Stconnect", "Begin", "Your", "Journey!"],
                              textStyle: TextStyle(
                                color: Colors.blue,
                                fontFamily: 'BebasNeue',
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width *
                                  (25 / 100),
                              child: Divider(
                                color: Colors.lightBlue,
                              ),
                            )
                          ],
                        ),
                      ),
                      _buildbutton("Continue as a Teacher", () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return TeacherSelectSubs();
                        }));
                      }),
                      _buildbutton("Register as a Student", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return StudentRegistration();
                            },
                          ),
                        );
                      }),
                      _agreementbutton()
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
