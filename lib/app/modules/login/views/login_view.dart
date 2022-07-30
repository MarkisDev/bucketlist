import 'package:blobs/blobs.dart';
import 'package:bucketlist/app/ui/theme/color_theme.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    return Scaffold(
      backgroundColor: kprimaryBackgroundColor,
      body: SafeArea(
        child: Center(
            child: Container(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          height: height * 0.4,
          width: width * 0.9,
          decoration: BoxDecoration(
              color: kprimaryColor,
              borderRadius: BorderRadius.all(Radius.circular(18))),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      'Sign-in to start building your own bucketlist!',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                        letterSpacing: -0.25,
                      ),
                    ),
                  ),
                ),
                TextButton(
                    child: Text(
                      'Login with Google',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    onPressed: () {
                      controller.loginWithGoogle();
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                        backgroundColor: MaterialStateProperty.all(
                            ksecondaryBackgroundColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))))
              ]),
        )),
      ),
    );
  }
}
