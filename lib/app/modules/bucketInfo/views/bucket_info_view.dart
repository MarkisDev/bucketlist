import 'package:bucketlist/app/ui/theme/color_theme.dart';
import 'package:bucketlist/app/ui/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import 'package:get/get.dart';
import 'package:listview_utils/listview_utils.dart';

import '../controllers/bucket_info_controller.dart';

class BucketInfoView extends GetView<BucketInfoController> {
  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    return Scaffold(
      backgroundColor: kprimaryBackgroundColor,
      appBar: kappBar,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ksecondaryColor,
        onPressed: () {},
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: Column(children: [
        SizedBox(
          height: height * 0.02,
        ),
        Expanded(
          child: GlowingOverscrollIndicator(
              color: kprimaryColor,
              axisDirection: AxisDirection.down,
              child: CustomListView(
                header: Column(children: [
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Center(
                      child: Container(
                    decoration: BoxDecoration(
                        color: ksecondaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(18))),
                    width: width * 0.91,
                    height: height * 0.15,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${controller.args.creatorInfo['firstName']}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 26,
                                    letterSpacing: -0.25,
                                  ),
                                ),
                                Text(
                                  '${controller.args.creatorInfo['lastName']}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 26,
                                    letterSpacing: -0.25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Container(
                                margin: EdgeInsets.only(left: 41),
                                padding: EdgeInsets.fromLTRB(7, 7, 7, 7),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 4),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: GestureDetector(
                                    onTap: () async {
                                      await Clipboard.setData(ClipboardData(
                                          text: controller.args.bucketId));
                                      Get.snackbar(
                                        'Success!',
                                        'Copied Bucket ID!',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: ksecondaryColor,
                                        borderRadius: 20,
                                        margin: EdgeInsets.all(15),
                                        colorText: Colors.black,
                                        duration: Duration(seconds: 4),
                                        isDismissible: true,
                                        dismissDirection:
                                            DismissDirection.horizontal,
                                        forwardAnimationCurve:
                                            Curves.easeOutBack,
                                      );
                                    },
                                    child: Text(
                                      '${controller.args.bucketId}',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: -0.25),
                                    ))),
                          )
                        ]),
                  )),
                  SizedBox(
                    height: height * 0.03,
                  ),
                ]),
                separatorBuilder: (context, _) {
                  return SizedBox(height: height * 0.02);
                },
                itemCount: 1,
                footer: SizedBox(height: height * 0.02),
                itemBuilder: (context, _, item) {
                  return GestureDetector(
                    onTap: () {},
                    child: Center(
                      child: Container(
                        width: width * 0.91,
                        height: height * 0.10,
                        decoration: BoxDecoration(
                            color: ksecondaryBackgroundColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(18))),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                flex: 3,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Hello",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontFamily: 'Raleway',
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: -0.25),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          'Testing',
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
                                    color: ksecondaryColor,
                                    thickness: 3.5,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '0',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 23,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )),
        ),
      ]),
    );
  }
}