import 'package:bucketlist/app/data/models/bucket_entries_model.dart';
import 'package:bucketlist/app/data/providers/firestore_provider.dart';
import 'package:bucketlist/app/ui/theme/color_theme.dart';
import 'package:bucketlist/app/ui/widgets/appBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:timeago/timeago.dart' as timeago;

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
        onPressed: () {
          controller.newEntry = true;
          Get.toNamed('bucket-entry', arguments: {
            "userModel": controller.userModel,
            "bucketModel": controller.bucketModel
          });
        },
        child: const Icon(
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
              color: Colors.lightGreen,
              axisDirection: AxisDirection.down,
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirestoreDb.getBucketEntries(
                        controller.bucketModel.id!),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: kprimaryColor,
                        ));
                      } else {
                        controller.entries.value = snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          return BucketEntriesModel.fromDocumentSnapshot(
                              documentSnapshot: document);
                        }).toList();
                      }
                      return CustomListView(
                        header: Column(children: [
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Center(
                              child: Container(
                            decoration: BoxDecoration(
                                color: ksecondaryColor,
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
                                          '${controller.bucketModel.creatorInfo['firstName']}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 26,
                                            letterSpacing: -0.25,
                                          ),
                                        ),
                                        Text(
                                          '${controller.bucketModel.creatorInfo['lastName']}',
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
                                        margin: const EdgeInsets.only(left: 41),
                                        padding: const EdgeInsets.fromLTRB(
                                            7, 7, 7, 7),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black, width: 4),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12))),
                                        child: GestureDetector(
                                            onTap: () async {
                                              await Clipboard.setData(
                                                  ClipboardData(
                                                      text: controller
                                                          .bucketModel
                                                          .bucketId));
                                              Get.snackbar(
                                                'Success!',
                                                'Copied Bucket ID!',
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                backgroundColor: kprimaryColor,
                                                borderRadius: 20,
                                                margin:
                                                    const EdgeInsets.all(15),
                                                colorText: Colors.black,
                                                duration:
                                                    const Duration(seconds: 4),
                                                isDismissible: true,
                                                dismissDirection:
                                                    DismissDirection.horizontal,
                                                forwardAnimationCurve:
                                                    Curves.easeOutBack,
                                              );
                                            },
                                            child: Text(
                                              '${controller.bucketModel.bucketId}',
                                              style: const TextStyle(
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
                        itemCount: controller.entries.length,
                        footer: SizedBox(height: height * 0.02),
                        itemBuilder: (context, _, item) {
                          return GestureDetector(
                            onTap: () async {
                              controller.newEntry = false;
                              if (!controller.entries[_].mutexInfo['lock']) {
                                var userModel = controller.userModel;
                                var data = {
                                  "lock": true,
                                  "id": userModel.id,
                                  "fullName": userModel.fullName,
                                  "firstName": userModel.firstName,
                                  "lastName": userModel.lastName,
                                  "email": userModel.email,
                                  "timestamp":
                                      DateTime.now().toUtc().toIso8601String(),
                                };
                                await FirestoreDb.updateMutex(
                                    controller.bucketModel.id!,
                                    controller.entries[_].id!,
                                    data);
                                Get.toNamed('bucket-entry', arguments: {
                                  "userModel": controller.userModel,
                                  "bucketModel": controller.bucketModel,
                                  "bucketData": controller.entries[_],
                                });
                              } else {
                                Get.defaultDialog(
                                    title: "Oops!",
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
                                        Text(
                                          "This entry is currently being edited by ${controller.entries[_].mutexInfo['fullName']}",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12),
                                          child: TextButton(
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
                                        )
                                      ],
                                    ));
                              }
                            },
                            onLongPress: () {
                              if (controller.entries[_].mutexInfo['lock']) {
                                Get.defaultDialog(
                                    title: "Oops!",
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
                                        Text(
                                          "This entry is currently being edited by ${controller.entries[_].mutexInfo['fullName']}",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12),
                                          child: TextButton(
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
                                        )
                                      ],
                                    ));
                              } else {
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
                                          "This will delete this entry and is irreversible!",
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
                                                  await FirestoreDb
                                                      .deleteBucketEntry(
                                                          controller
                                                              .userModel.id,
                                                          controller
                                                              .bucketModel.id!,
                                                          controller
                                                              .entries[_].id!);
                                                  Get.closeAllSnackbars();
                                                  Get.close(1);
                                                  Get.snackbar(
                                                    'Deleted!',
                                                    'Deleted the entry!',
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                    backgroundColor: Colors.red,
                                                    borderRadius: 20,
                                                    margin:
                                                        const EdgeInsets.all(
                                                            15),
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
                              }
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
                                        child: Text(
                                          '${controller.entries[_].entryInfo['title']}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Transform.rotate(
                                          angle: 30 * math.pi / 180,
                                          child: VerticalDivider(
                                            color: ksecondaryColor,
                                            thickness: 3.5,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${controller.entries[_].mutexInfo['firstName']}",
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                    fontFamily: 'Raleway',
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: -0.25),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: Text(
                                                  timeago.format(DateTime.parse(
                                                      controller.entries[_]
                                                              .mutexInfo[
                                                          'timestamp'])),
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
              )),
        ),
      ]),
    );
  }
}
