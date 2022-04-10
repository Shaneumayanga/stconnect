import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stconnect/finalize_screens/finalize_teacher.dart';
import 'package:stconnect/utils/constants.dart';

class TeacherEnterDetails extends StatefulWidget {
  final selectedsubs;
  final bio;

  TeacherEnterDetails({
    this.selectedsubs,
    this.bio,
  });
  @override
  _TeacherEnterDetailsState createState() => _TeacherEnterDetailsState();
}

class _TeacherEnterDetailsState extends State<TeacherEnterDetails> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phonenumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confrimpassword = TextEditingController();
  String selecteddistrict;


//do the districts
  List<String> districts = [
    "Not Selected",
    "Ampara",
    "Anuradhapura",
    "Badulla",
    "Batticaloa",
    "Colombo",
    "Galle",
    "Gampaha",
    "Hambantota",
    "Jaffna",
    "Kalutara",
    "Kandy",
    "Kegalle",
    "Kilinochchi",
    "Kurunegala",
    "Mannar",
    "Matale",
    "Matara",
    "Monaragala",
    "Mullativu",
    "NuwaraEliya",
    "Polonnaruwa",
    "Puttalam",
    "Ratnapura",
    "Trincomalee",
    "Vavuniya"
  ];

  @override
  initState() {
    super.initState();
    this.selecteddistrict = this.districts[0];
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
          style: kLabelStyle,
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

  Widget buildButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: gotofinalize,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Register',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget buildbox(double h) {
    return SizedBox(
      height: h,
    );
  }

  Widget builddistrictsSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select a District',
          style: kLabelStyle,
        ),
        DropdownButton<String>(
          value: selecteddistrict,
          dropdownColor: Colors.blue,
          items: districts.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
              ),
            );
          }).toList(),
          onChanged: (val) {
            setState(() {
              this.selecteddistrict = val;
            });
          },
        ),
      ],
    );
  }

  void gotofinalize() {
    var subs = widget.selectedsubs;
    var passwordtext = password.text;
    var confirmpasswordtext = confrimpassword.text;
    var emailtext = email.text;
    var usernametext = username.text;
    var phonenumbertext = phonenumber.text;
    if (passwordtext == confirmpasswordtext) {
      if (emailtext != "" && usernametext != "" && phonenumbertext != "") {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return FinalizeTeacher(
            subs: subs,
            password: passwordtext,
            email: emailtext,
            phonenumber: phonenumbertext,
            username: usernametext,
            bio: widget.bio,
          );
        }));
      } else {
        CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            text: "Some Fields are empty");
      }
    } else {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: "Passwords doesn't match");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF73AEF5),
                    Color(0xFF61A4F1),
                    Color(0xFF478DE0),
                    Color(0xFF398AE5),
                  ],
                  stops: [0.1, 0.4, 0.7, 0.9],
                )),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildTF(username, "Full name", "Enter your full name",
                          Icons.account_box, TextInputType.name, false),
                      buildbox(10),
                      buildTF(email, "Email", "Enter a valid email",
                          Icons.email, TextInputType.emailAddress, false),
                      buildbox(10),
                      buildTF(password, "Password", "Enter a password",
                          Icons.lock, TextInputType.visiblePassword, true),
                      buildbox(10),
                      buildTF(
                          confrimpassword,
                          "Confirm password",
                          "Confirm your password",
                          Icons.lock,
                          TextInputType.visiblePassword,
                          true),
                      buildbox(10),
                      buildTF(phonenumber, "Phone number", "+94XXXXXXXXX",
                          Icons.phone, TextInputType.phone, false),
                      buildbox(10),
                      // builddistrictsSelector(),
                      // buildbox(10),
                      buildButton(),
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
