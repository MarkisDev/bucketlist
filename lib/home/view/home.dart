import 'package:flutter/material.dart';
import 'package:bucketlist/utils/constants.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    return Scaffold(
      appBar: Constants.kappBar,
      body: Column(children: [
        SizedBox(
          height: height * 0.02,
        ),
        Center(
            child: Container(
          decoration: BoxDecoration(
              color: Constants.kprimaryColor,
              borderRadius: BorderRadius.all(Radius.circular(18))),
          width: width * 0.91,
          height: height * 0.15,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rijuth',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 26,
                      letterSpacing: -0.25,
                    ),
                  ),
                  Text(
                    'Menon',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 26,
                      letterSpacing: -0.25,
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                  margin: EdgeInsets.only(left: 41),
                  padding: EdgeInsets.fromLTRB(7, 7, 7, 7),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 4),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Text(
                    'UNODICK',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.25),
                  )),
            )
          ]),
        )),
        SizedBox(height: height * 0.06),
        Center(G
          child: Container(
            width: width * 0.91,
            height: height * 0.12,
            decoration: BoxDecoration(
                color: Constants.ksecondaryBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(18))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            'Rijuth Menon',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.25),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            'NOUDICK',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.15),
                          ),
                        ),
                      ]),
                ),
                Flexible(
                  flex: 3,
                  child: Transform.rotate(
                    angle: 30 * math.pi / 180,
                    child: VerticalDivider(
                      color: Constants.kprimaryColor,
                      thickness: 5,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '89',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: height * 0.02),
        Center(
          child: Container(
            width: width * 0.91,
            height: height * 0.12,
            decoration: BoxDecoration(
                color: Constants.ksecondaryBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(18))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            'Rijuth Menon',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.25),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            'NOUDICK',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.15),
                          ),
                        ),
                      ]),
                ),
                Flexible(
                  flex: 3,
                  child: Transform.rotate(
                    angle: 30 * math.pi / 180,
                    child: VerticalDivider(
                      color: Constants.kprimaryColor,
                      thickness: 5,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '89',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: height * 0.02),
        Center(
          child: Container(
            width: width * 0.91,
            height: height * 0.12,
            decoration: BoxDecoration(
                color: Constants.ksecondaryBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(18))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            'Aditya Vamsi',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.25),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            'NOUDICK',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.15),
                          ),
                        ),
                      ]),
                ),
                Flexible(
                  flex: 3,
                  child: Transform.rotate(
                    angle: 30 * math.pi / 180,
                    child: VerticalDivider(
                      color: Constants.kprimaryColor,
                      thickness: 5,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '89',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
