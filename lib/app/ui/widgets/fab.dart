import 'package:bucketlist/app/ui/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget addBucketFab() {
  return TextButton.icon(
    onPressed: () {},
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
                    .checkUnique(controller.bucketIdController.text)) {
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
