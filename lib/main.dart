import 'package:bucketlist/home/view/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bucketlist/home/view/home.dart';
import 'package:bucketlist/utils/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Constants.kprimaryBackgroundColor,
        fontFamily: 'Poppins',
        // is not restarted.
        primaryColor: Constants.kprimaryColor,
      ),
      home: Loginpage(),
    );
  }
}
