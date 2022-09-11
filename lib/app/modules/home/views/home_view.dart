import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:bucketlist/app/data/providers/realtime_provider.dart';
import 'package:bucketlist/app/modules/login/controllers/login_controller.dart';
import 'package:bucketlist/app/ui/theme/color_theme.dart';
import 'package:bucketlist/app/ui/widgets/appBar.dart';
import 'package:bucketlist/app/ui/widgets/fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:listview_utils/listview_utils.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    return Scaffold(
      floatingActionButton: AnimatedFloatingActionButton(
        //Fab list
        fabButtons: <Widget>[
          joinBucketFab(controller),
          addBucketFab(controller)
        ],
        key: key,
        colorStartAnimation: ksecondaryBackgroundColor,
        colorEndAnimation: ksecondaryBackgroundColor,
        animatedIconData: AnimatedIcons.menu_close,
        tooltip: "Join or add a bucket!", //To principal button
      ),
      backgroundColor: kprimaryBackgroundColor,
      appBar: kappBar,
      body: Column(children: [
        SizedBox(
          height: height * 0.02,
        ),
        Obx(
          () => Expanded(
            child: GlowingOverscrollIndicator(
                color: kprimaryColor,
                axisDirection: AxisDirection.down,
                child: CustomListView(
                  header: Column(children: [
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Center(
                        child: InkWell(
                      onLongPress: () {
                        Get.bottomSheet(
                          SizedBox(
                            width: width * 0.1,
                            child: TextButton(
                              child: Text("Sign Out!",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              onPressed: () {
                                controller.loginController.logoutGoogle();
                              },
                              style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                      ksecondaryBackgroundColor
                                          .withOpacity(0.2)),
                                  backgroundColor:
                                      MaterialStateProperty.all(kprimaryColor),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ))),
                            ),
                          ),
                          backgroundColor: kprimaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: kprimaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(18))),
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
                                      '${controller.args.firstName}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 26,
                                        letterSpacing: -0.25,
                                      ),
                                    ),
                                    Text(
                                      '${controller.args.lastName}',
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
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
                                        onLongPress: () async {
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
                      ),
                    )),
                    SizedBox(
                      height: height * 0.03,
                    ),
                  ]),
                  separatorBuilder: (context, _) {
                    return SizedBox(height: height * 0.02);
                  },
                  itemCount: controller.bucketList.length,
                  footer: SizedBox(height: height * 0.02),
                  itemBuilder: (context, _, item) {
                    if (controller.args.bucketId ==
                        controller.bucketList[_].bucketId) {
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed('bucket-info',
                              arguments: controller.bucketList[_]);
                        },
                        child: Center(
                          child: Container(
                            width: width * 0.91,
                            height: height * 0.10,
                            decoration: BoxDecoration(
                                color: ksecondaryBackgroundColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18))),
                            child: ClipRect(
                              child: Banner(
                                message: "private",
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'poppins',
                                    letterSpacing: -0.5,
                                    fontSize: 14),
                                location: BannerLocation.topEnd,
                                color: kprimaryColor,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${controller.bucketList[_].creatorInfo['fullName']}",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                    fontFamily: 'Raleway',
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: -0.25),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: Text(
                                                  '${controller.bucketList[_].bucketId}',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontFamily: 'Raleway',
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                            color: kprimaryColor,
                                            thickness: 3.5,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${controller.bucketList[_].totalEntries}',
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
                          ),
                        ),
                        onLongPress: () {
                          Get.defaultDialog(
                              title: "Error!",
                              titlePadding: EdgeInsets.fromLTRB(0, 21, 0, 0),
                              backgroundColor: kprimaryColor,
                              titleStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 23,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500),
                              contentPadding: EdgeInsets.all(21),
                              content: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "You cannot delete your private bucket!",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: Text(
                                              "Okay!",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontFamily: 'Raleway'),
                                            ),
                                          ),
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      ksecondaryBackgroundColor),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18.0),
                                                      side: BorderSide(
                                                          color:
                                                              Colors.black)))),
                                          onPressed: () async {
                                            Get.back();
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ));
                        },
                      );
                    }
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed('bucket-info',
                            arguments: controller.bucketList[_]);
                      },
                      onLongPress: () {
                        Get.defaultDialog(
                            title: "Are you sure?",
                            titlePadding: EdgeInsets.fromLTRB(0, 21, 0, 0),
                            backgroundColor: kprimaryColor,
                            titleStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 23,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                            contentPadding: EdgeInsets.all(21),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "This will delete this bucket and all its entries!",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      TextButton(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontFamily: 'Raleway'),
                                          ),
                                        ),
                                        style: ButtonStyle(
                                            overlayColor: MaterialStateProperty.all(
                                                Colors.white.withOpacity(0.15)),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    ksecondaryBackgroundColor),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                    side: BorderSide(
                                                        color: Colors.black)))),
                                        onPressed: () async {
                                          controller.repository.deleteBucket(
                                              controller
                                                  .bucketList[_].bucketId);
                                          Get.closeAllSnackbars();
                                          Get.close(1);
                                          Get.snackbar(
                                            'Deleted!',
                                            'Deleted the bucket!',
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: Colors.red,
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
                                      ),
                                      TextButton(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: Text(
                                            "Go back",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontFamily: 'Raleway'),
                                          ),
                                        ),
                                        style: ButtonStyle(
                                            overlayColor: MaterialStateProperty.all(
                                                Colors.white.withOpacity(0.15)),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    ksecondaryBackgroundColor),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                    side: BorderSide(
                                                        color: kprimaryBackgroundColor)))),
                                        onPressed: () {
                                          Get.back();
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ));
                      },
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${controller.bucketList[_].creatorInfo['fullName']}",
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
                                            '${controller.bucketList[_].bucketId}',
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
                                      color: kprimaryColor,
                                      thickness: 3.5,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${controller.bucketList[_].totalEntries}',
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
        ),
      ]),
    );
  }
}
