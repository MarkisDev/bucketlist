import 'package:flutter/material.dart';

class Constants {
  static Color kprimaryColor = Color(0xffAFFC41);
  static Color ksecondaryColor = Color(0xffB8E9C4);
  static Color kprimaryBackgroundColor = Colors.black;
  static Color ksecondaryBackgroundColor = Color(0xff1d1d1d);

  static AppBar kappBar = AppBar(
    title: Text(
      'bucketlist',
      style: TextStyle(
          fontWeight: FontWeight.w700, fontSize: 26, letterSpacing: -0.25),
    ),
    backgroundColor: Constants.kprimaryBackgroundColor,
    centerTitle: true,
  );
}
