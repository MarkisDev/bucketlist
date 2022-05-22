import 'package:flutter/material.dart';
import 'package:bucketlist/utils/constants.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class Loginpage extends StatelessWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constants.kappBar,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(
            child: SignInButton(
          Buttons.Google,
          onPressed: () {},
        )),
      ]),
    );
  }
}
