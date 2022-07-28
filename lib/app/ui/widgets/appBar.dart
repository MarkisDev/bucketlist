import 'package:bucketlist/app/ui/theme/color_theme.dart';
import 'package:flutter/material.dart';

AppBar kappBar = AppBar(
  title: Text(
    'bucketlist',
    style: TextStyle(
        fontWeight: FontWeight.w700, fontSize: 26, letterSpacing: -0.25),
  ),
  backgroundColor: kprimaryBackgroundColor,
  centerTitle: true,
);
