import 'package:bucketlist/app/data/models/bucket_model.dart';
import 'package:bucketlist/app/data/models/user_model.dart';
import 'package:bucketlist/app/ui/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

Widget addBucketFab(var controller) {
  return TextButton.icon(
    onPressed: () async {
      // Setting a new value for newBucketId
      controller.newBucketId.value = await BucketModel.genId();
      Get.defaultDialog(
          title: "Create a bucketlist!",
          titlePadding: EdgeInsets.fromLTRB(0, 21, 0, 0),
          backgroundColor: kprimaryColor,
          titleStyle: TextStyle(
              color: Colors.black,
              fontSize: 23,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500),
          contentPadding: EdgeInsets.all(21),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Obx(() {
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                    child: Text(
                      "${controller.newBucketId.value}",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(width: 4, color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                );
              }),
              IconButton(
                  onPressed: () async {
                    controller.newBucketId.value = await BucketModel.genId();
                  },
                  icon: Icon(
                    Icons.refresh,
                    size: 34,
                    color: Colors.black,
                  ))
            ],
          ),
          // content: Column(
          //   children: [
          // TextField(
          //   controller: controller.bucketIdController,
          //   style: TextStyle(
          //       color: Colors.black,
          //       fontSize: 18,
          //       fontFamily: 'Poppins',
          //       fontWeight: FontWeight.w600),
          //   cursorColor: Colors.black,
          //   decoration: InputDecoration(
          //     enabledBorder: OutlineInputBorder(
          //         borderSide: BorderSide(color: Colors.black, width: 4),
          //         borderRadius: BorderRadius.all(Radius.circular(12))),
          //     border: OutlineInputBorder(
          //         borderSide: BorderSide(color: Colors.black, width: 4),
          //         borderRadius: BorderRadius.all(Radius.circular(12))),
          //     focusedBorder: OutlineInputBorder(
          //         borderSide: BorderSide(color: Colors.black, width: 4),
          //         borderRadius: BorderRadius.all(Radius.circular(12))),
          //     hintText: 'Bucket ID',
          //   ),
          // ),

          // Obx(
          //   () {
          //     return Padding(
          //       padding: EdgeInsets.fromLTRB(10, 10.0, 0.0, 0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         children: [
          //           Text(
          //             'Private',
          //             style: TextStyle(
          //                 color: Colors.black,
          //                 fontSize: 18,
          //                 fontFamily: 'Poppins',
          //                 fontWeight: FontWeight.w600),
          //           ),
          //           Padding(
          //             padding: const EdgeInsets.only(left: 8.0),
          //             child: FlutterSwitch(
          //                 height: 25,
          //                 width: 50,
          //                 value: controller.switchVal.value,
          //                 onToggle: (bool value) {
          //                   controller.switchVal.value =
          //                       !controller.switchVal.value;
          //                 }),
          //           )
          //         ],
          //       ),
          //     );
          //   },
          // ),
          // ],
          // ),
          buttonColor: ksecondaryBackgroundColor,
          confirm: TextButton(
              onPressed: () async {
                bool exists = await controller.repository
                    .checkBucket(controller.newBucketId.value);
                if (!exists) {
                  UserModel userModel = controller.args;
                  BucketModel bucketModel = BucketModel(
                      creatorInfo: {
                        "id": userModel.id,
                        "fullName": userModel.fullName,
                        "firstName": userModel.firstName,
                        "lastName": userModel.lastName,
                      },
                      members: {
                        userModel.id: {
                          "timestamp": DateTime.now().toUtc().toIso8601String(),
                          "entries": 0,
                          "fullName": userModel.fullName,
                          "firstName": userModel.firstName,
                          "lastName": userModel.lastName,
                        },
                      },
                      bucketId: controller.newBucketId.value,
                      totalEntries: 0,
                      private: true);

                  if (await controller.repository.addBucket(bucketModel)) {
                    // Registering new bucket to user
                    controller.repository
                        .registerBucket(userModel, bucketModel.bucketId);
                    Get.snackbar(
                      'Success!',
                      'Created new bucket!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: ksecondaryColor,
                      borderRadius: 20,
                      margin: EdgeInsets.all(15),
                      colorText: Colors.black,
                      duration: Duration(seconds: 4),
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
                      margin: EdgeInsets.all(15),
                      colorText: Colors.black,
                      duration: Duration(seconds: 4),
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
                    margin: EdgeInsets.all(15),
                    colorText: Colors.black,
                    duration: Duration(seconds: 4),
                    isDismissible: true,
                    dismissDirection: DismissDirection.horizontal,
                    forwardAnimationCurve: Curves.easeOutBack,
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Create",
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, fontFamily: 'Raleway'),
                ),
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(ksecondaryBackgroundColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.black))))));
    },
    icon: Icon(
      Icons.delete_outlined,
      color: Colors.black,
    ),
    label: Padding(
        padding: const EdgeInsets.only(right: 8.0, top: 3.0, bottom: 3.0),
        child: Text("Create a bucket",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black))),
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(kprimaryColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ))),
  );
}

// Join Bucket Fab
Widget joinBucketFab(var controller) {
  return TextButton.icon(
    onPressed: () {
      Get.defaultDialog(
          title: "Join a bucketlist!",
          titlePadding: EdgeInsets.fromLTRB(0, 21, 0, 0),
          backgroundColor: kprimaryColor,
          titleStyle: TextStyle(
              color: Colors.black,
              fontSize: 23,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500),
          contentPadding: EdgeInsets.all(21),
          content: TextField(
            controller: controller.bucketIdController,
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600),
            cursorColor: Colors.black,
            decoration: InputDecoration(
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
                if (await controller.repository
                    .checkBucket(controller.bucketIdController.text)) {
                  if (await controller.repository.registerBucket(
                      controller.args, controller.bucketIdController.text)) {
                    Get.snackbar(
                      'Success!',
                      'Added new bucket!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: ksecondaryColor,
                      borderRadius: 20,
                      margin: EdgeInsets.all(15),
                      colorText: Colors.black,
                      duration: Duration(seconds: 4),
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
                      margin: EdgeInsets.all(15),
                      colorText: Colors.black,
                      duration: Duration(seconds: 4),
                      isDismissible: true,
                      dismissDirection: DismissDirection.horizontal,
                      forwardAnimationCurve: Curves.easeOutBack,
                    );
                  }
                } else {
                  Get.snackbar(
                    'Error!',
                    'Bucket doesn\'t exist!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    borderRadius: 20,
                    margin: EdgeInsets.all(15),
                    colorText: Colors.black,
                    duration: Duration(seconds: 4),
                    isDismissible: true,
                    dismissDirection: DismissDirection.horizontal,
                    forwardAnimationCurve: Curves.easeOutBack,
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Join",
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, fontFamily: 'Raleway'),
                ),
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(ksecondaryBackgroundColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.black))))));
    },
    icon: Icon(
      Icons.add,
      color: Colors.black,
    ),
    label: Padding(
      padding: const EdgeInsets.only(right: 8.0, top: 3.0, bottom: 3.0),
      child: Text("Join a bucket",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black)),
    ),
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(kprimaryColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ))),
  );
}
