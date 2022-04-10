import 'package:flutter/material.dart';

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBioLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 25.0,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

// Color(0xFF398AE5),

final kBoxTeacherCardDecorationStyle = BoxDecoration(
  // color:Color(0xFF398AE5),
  color: Colors.blue,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

final kBoxTeacherSubjectDeco = BoxDecoration(
  // color:Color(0xFF398AE5),
  color: Colors.white,
  borderRadius: BorderRadius.circular(50.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

final kteachernameTextStyle =
    TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w400);

bool isapptesting = true;
