import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:bucketlist/app/data/models/bucket_model.dart';
import 'package:bucketlist/app/data/models/user_model.dart';
import 'package:bucketlist/app/data/providers/firestore_provider.dart';
import 'package:bucketlist/app/ui/theme/color_theme.dart';
import 'package:bucketlist/app/ui/widgets/appBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:listview_utils/listview_utils.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    return Scaffold(
      floatingActionButton: AnimatedFloatingActionButton(
        //Fab list
        fabButtons: <Widget>[
          TextButton.icon(
            onPressed: () async {
              // Setting a new value for newBucketId
              controller.newBucketId.value = await BucketModel.genId();
              Get.defaultDialog(
                  title: "Create a bucketlist!",
                  titlePadding: const EdgeInsets.fromLTRB(0, 21, 0, 0),
                  backgroundColor: kprimaryColor,
                  titleStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 23,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500),
                  contentPadding: const EdgeInsets.all(21),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Obx(() {
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 4, color: Colors.black),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12))),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                            child: Text(
                              "${controller.newBucketId.value}",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        );
                      }),
                      IconButton(
                          onPressed: () async {
                            controller.newBucketId.value =
                                await BucketModel.genId();
                          },
                          icon: const Icon(
                            Icons.refresh,
                            size: 34,
                            color: Colors.black,
                          ))
                    ],
                  ),
                  buttonColor: ksecondaryBackgroundColor,
                  confirm: TextButton(
                      onPressed: () async {
                        bool exists = await FirestoreDb.checkBucket(
                            controller.newBucketId.value);
                        if (!exists) {
                          UserModel userModel = controller.args;
                          BucketModel bucketModel = BucketModel(
                              creatorInfo: UserModel.toMap(userModel),
                              members: [
                                userModel.id,
                              ],
                              timestamps: {
                                userModel.id:
                                    DateTime.now().toUtc().toIso8601String()
                              },
                              numEntries: {userModel.id: 0},
                              bucketId: controller.newBucketId.value,
                              totalEntries: 0,
                              private: false);

                          if (await FirestoreDb.addBucket(
                              userModel, bucketModel)) {
                            // Registering new bucket to user
                            Get.back();
                            Get.snackbar(
                              'Success!',
                              'Created new bucket!',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: ksecondaryColor,
                              borderRadius: 20,
                              margin: const EdgeInsets.all(15),
                              colorText: Colors.black,
                              duration: const Duration(seconds: 4),
                              isDismissible: true,
                              dismissDirection: DismissDirection.horizontal,
                              forwardAnimationCurve: Curves.easeOutBack,
                            );
                            // Get.back();
                          } else {
                            Get.snackbar(
                              'Error!',
                              'Already part of bucket!',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              borderRadius: 20,
                              margin: const EdgeInsets.all(15),
                              colorText: Colors.black,
                              duration: const Duration(seconds: 4),
                              isDismissible: true,
                              dismissDirection: DismissDirection.horizontal,
                              forwardAnimationCurve: Curves.easeOutBack,
                            );
                          }
                        } else {
                          Get.snackbar(
                            'Error!',
                            'Bucket already exists!',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            borderRadius: 20,
                            margin: const EdgeInsets.all(15),
                            colorText: Colors.black,
                            duration: const Duration(seconds: 4),
                            isDismissible: true,
                            dismissDirection: DismissDirection.horizontal,
                            forwardAnimationCurve: Curves.easeOutBack,
                          );
                        }
                      },
                      style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(
                              Colors.white.withOpacity(0.15)),
                          backgroundColor: MaterialStateProperty.all(
                              ksecondaryBackgroundColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: const BorderSide(
                                          color: Colors.black)))),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "Create",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Raleway'),
                        ),
                      )));
            },
            icon: const Icon(
              Icons.delete_outlined,
              color: Colors.black,
            ),
            label: const Padding(
                padding: EdgeInsets.only(right: 8.0, top: 3.0, bottom: 3.0),
                child: Text("Create a bucket",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black))),
            style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(
                    ksecondaryBackgroundColor.withOpacity(0.2)),
                backgroundColor: MaterialStateProperty.all(kprimaryColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ))),
          ),
          TextButton.icon(
            onPressed: () {
              Get.defaultDialog(
                  title: "Join a bucketlist!",
                  titlePadding: const EdgeInsets.fromLTRB(0, 21, 0, 0),
                  backgroundColor: kprimaryColor,
                  titleStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 23,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500),
                  contentPadding: const EdgeInsets.all(21),
                  content: TextField(
                    controller: controller.bucketIdController,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600),
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 4),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 4),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 4),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      hintText: 'Bucket ID',
                    ),
                  ),
                  buttonColor: ksecondaryBackgroundColor,
                  confirm: TextButton(
                      onPressed: () async {
                        // Fetching document to see if it exists
                        final QuerySnapshot querySnap =
                            await FirestoreDb.getBucket(
                                controller.bucketIdController.text);
                        if (querySnap.docs.isNotEmpty) {
                          // Converting fetched document to BucketModel to do other stuff
                          controller.checkBucket =
                              BucketModel.fromDocumentSnapshot(
                                  documentSnapshot: querySnap.docs.first);
                          if (controller.checkBucket!.private != false) {
                            Get.defaultDialog(
                                title: "Error!",
                                titlePadding:
                                    const EdgeInsets.fromLTRB(0, 21, 0, 0),
                                backgroundColor: kprimaryColor,
                                titleStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 23,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                                contentPadding: const EdgeInsets.all(21),
                                content: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "You cannot join a private bucket!",
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
                                            style: ButtonStyle(
                                                overlayColor:
                                                    MaterialStateProperty.all(
                                                        Colors.white
                                                            .withOpacity(0.15)),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        ksecondaryBackgroundColor),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                18.0),
                                                        side: const BorderSide(color: Colors.black)))),
                                            onPressed: () async {
                                              Get.back();
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.0),
                                              child: Text(
                                                "Okay!",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontFamily: 'Raleway'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ));
                          } else {
                            UserModel userModel = controller.args;
                            if (!controller.checkBucket!.members
                                .contains(userModel.id)) {
                              FirestoreDb.addMember(
                                  controller.checkBucket!.id!, userModel.id);
                              Get.back();

                              Get.snackbar(
                                'Success!',
                                'Added new bucket!',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: ksecondaryColor,
                                borderRadius: 20,
                                margin: const EdgeInsets.all(15),
                                colorText: Colors.black,
                                duration: const Duration(seconds: 4),
                                isDismissible: true,
                                dismissDirection: DismissDirection.horizontal,
                                forwardAnimationCurve: Curves.easeOutBack,
                              );
                              // Get.back();
                            } else {
                              Get.snackbar(
                                'Error!',
                                'Already part of bucket!',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                borderRadius: 20,
                                margin: const EdgeInsets.all(15),
                                colorText: Colors.black,
                                duration: const Duration(seconds: 4),
                                isDismissible: true,
                                dismissDirection: DismissDirection.horizontal,
                                forwardAnimationCurve: Curves.easeOutBack,
                              );
                            }
                          }
                        } else {
                          Get.snackbar(
                            'Error!',
                            'Bucket doesn\'t exist!',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            borderRadius: 20,
                            margin: const EdgeInsets.all(15),
                            colorText: Colors.black,
                            duration: const Duration(seconds: 4),
                            isDismissible: true,
                            dismissDirection: DismissDirection.horizontal,
                            forwardAnimationCurve: Curves.easeOutBack,
                          );
                        }
                      },
                      style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(
                              Colors.white.withOpacity(0.15)),
                          backgroundColor: MaterialStateProperty.all(
                              ksecondaryBackgroundColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: const BorderSide(
                                          color: Colors.black)))),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "Join",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Raleway'),
                        ),
                      )));
            },
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
            label: const Padding(
              padding: EdgeInsets.only(right: 8.0, top: 3.0, bottom: 3.0),
              child: Text("Join a bucket",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
            ),
            style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(
                    ksecondaryBackgroundColor.withOpacity(0.2)),
                backgroundColor: MaterialStateProperty.all(kprimaryColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ))),
          ),
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
        Container(
          child: Expanded(
            child: GlowingOverscrollIndicator(
              color: kprimaryColor,
              axisDirection: AxisDirection.down,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirestoreDb.getBuckets(controller.args),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: kprimaryColor,
                      ));
                    } else {
                      controller.bucketList.value =
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        return BucketModel.fromDocumentSnapshot(
                            documentSnapshot: document);
                      }).toList();

                      return CustomListView(
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
                                    onPressed: () {
                                      controller.loginController.logoutGoogle();
                                    },
                                    style: ButtonStyle(
                                        overlayColor: MaterialStateProperty.all(
                                            ksecondaryBackgroundColor
                                                .withOpacity(0.2)),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                kprimaryColor),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ))),
                                    child: const Text("Sign Out!",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(18))),
                              width: width * 0.91,
                              height: height * 0.15,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${controller.args.firstName}',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 26,
                                              letterSpacing: -0.25,
                                            ),
                                          ),
                                          Text(
                                            '${controller.args.lastName}',
                                            style: const TextStyle(
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
                                          margin:
                                              const EdgeInsets.only(left: 41),
                                          padding: const EdgeInsets.fromLTRB(
                                              7, 7, 7, 7),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 4),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(12))),
                                          child: GestureDetector(
                                              onTap: () async {
                                                await Clipboard.setData(
                                                    ClipboardData(
                                                        text: controller
                                                            .args.bucketId));
                                                Get.snackbar(
                                                  'Success!',
                                                  'Copied Bucket ID!',
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                  backgroundColor:
                                                      ksecondaryColor,
                                                  borderRadius: 20,
                                                  margin:
                                                      const EdgeInsets.all(15),
                                                  colorText: Colors.black,
                                                  duration: const Duration(
                                                      seconds: 4),
                                                  isDismissible: true,
                                                  dismissDirection:
                                                      DismissDirection
                                                          .horizontal,
                                                  forwardAnimationCurve:
                                                      Curves.easeOutBack,
                                                );
                                              },
                                              onLongPress: () async {
                                                await Clipboard.setData(
                                                    ClipboardData(
                                                        text: controller
                                                            .args.bucketId));
                                                Get.snackbar(
                                                  'Success!',
                                                  'Copied Bucket ID!',
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                  backgroundColor:
                                                      ksecondaryColor,
                                                  borderRadius: 20,
                                                  margin:
                                                      const EdgeInsets.all(15),
                                                  colorText: Colors.black,
                                                  duration: const Duration(
                                                      seconds: 4),
                                                  isDismissible: true,
                                                  dismissDirection:
                                                      DismissDirection
                                                          .horizontal,
                                                  forwardAnimationCurve:
                                                      Curves.easeOutBack,
                                                );
                                              },
                                              child: Text(
                                                '${controller.args.bucketId}',
                                                style: const TextStyle(
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
                          if (controller.bucketList[_].private == true) {
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
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(18))),
                                  child: ClipRect(
                                    child: Banner(
                                      message: "private",
                                      textStyle: const TextStyle(
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
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white,
                                                          fontFamily: 'Raleway',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: -0.25),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0),
                                                      child: Text(
                                                        '${controller.bucketList[_].bucketId}',
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Raleway',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            letterSpacing:
                                                                0.15),
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
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 23,
                                                    fontWeight:
                                                        FontWeight.w500),
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
                                    titlePadding:
                                        const EdgeInsets.fromLTRB(0, 21, 0, 0),
                                    backgroundColor: kprimaryColor,
                                    titleStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 23,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500),
                                    contentPadding: const EdgeInsets.all(21),
                                    content: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "You cannot delete your private bucket!",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              TextButton(
                                                style: ButtonStyle(
                                                    overlayColor:
                                                        MaterialStateProperty.all(
                                                            Colors.white
                                                                .withOpacity(
                                                                    0.15)),
                                                    backgroundColor:
                                                        MaterialStateProperty.all(
                                                            ksecondaryBackgroundColor),
                                                    shape: MaterialStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(18.0),
                                                            side: const BorderSide(color: Colors.black)))),
                                                onPressed: () async {
                                                  Get.back();
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                                  child: Text(
                                                    "Okay!",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontFamily: 'Raleway'),
                                                  ),
                                                ),
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
                                  titlePadding:
                                      const EdgeInsets.fromLTRB(0, 21, 0, 0),
                                  backgroundColor: kprimaryColor,
                                  titleStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 23,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500),
                                  contentPadding: const EdgeInsets.all(21),
                                  content: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "This will delete this bucket and all its entries!",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            TextButton(
                                              style: ButtonStyle(
                                                  overlayColor:
                                                      MaterialStateProperty.all(
                                                          Colors.white
                                                              .withOpacity(
                                                                  0.15)),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          ksecondaryBackgroundColor),
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(18.0),
                                                          side: const BorderSide(color: Colors.black)))),
                                              onPressed: () async {
                                                await FirestoreDb.removeMember(
                                                    controller.bucketList[_].id,
                                                    controller.args.id);
                                                Get.closeAllSnackbars();
                                                Get.close(1);
                                                Get.snackbar(
                                                  'Deleted!',
                                                  'Deleted the bucket!',
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                  backgroundColor: Colors.red,
                                                  borderRadius: 20,
                                                  margin:
                                                      const EdgeInsets.all(15),
                                                  colorText: Colors.black,
                                                  duration: const Duration(
                                                      seconds: 4),
                                                  isDismissible: true,
                                                  dismissDirection:
                                                      DismissDirection
                                                          .horizontal,
                                                  forwardAnimationCurve:
                                                      Curves.easeOutBack,
                                                );
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.0),
                                                child: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontFamily: 'Raleway'),
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              style: ButtonStyle(
                                                  overlayColor:
                                                      MaterialStateProperty.all(
                                                          Colors.white
                                                              .withOpacity(
                                                                  0.15)),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          ksecondaryBackgroundColor),
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(18.0),
                                                          side: BorderSide(color: kprimaryBackgroundColor)))),
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.0),
                                                child: Text(
                                                  "Go back",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontFamily: 'Raleway'),
                                                ),
                                              ),
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(18))),
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
                                                style: const TextStyle(
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
                                                  style: const TextStyle(
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
                                          style: const TextStyle(
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
                      );
                    }
                  }),
            ),
          ),
        ),
      ]),
    );
  }
}
