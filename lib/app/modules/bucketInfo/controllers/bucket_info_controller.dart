import 'dart:async';

import 'package:bucketlist/app/data/models/user_model.dart';
import 'package:bucketlist/app/data/providers/realtime_provider.dart';
import 'package:bucketlist/app/data/repositories/bucket_repository.dart';
import 'package:bucketlist/app/data/repositories/user_repository.dart';
import 'package:bucketlist/app/modules/home/controllers/home_controller.dart';
import 'package:bucketlist/app/ui/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BucketInfoController extends GetxController {
  var bucketModel = Get.arguments;
  final BucketRepository repository;
  late final UserModel userModel;
  BucketInfoController({required this.repository});
  var newEntry = true;
  var entries = [].obs;
  var criticalInfoChanged = false.obs;
  late StreamSubscription criticalInfoSub;

  @override
  void onInit() {
    super.onInit();
    HomeController homeController = Get.find<HomeController>();
    userModel = homeController.args;
    // var x = repository.getBucketEntries(bucketModel.bucketId).listen((event) {
    //   entries.value = event;
    // });
    entries.bindStream(repository.getBucketEntries(bucketModel.bucketId));
    // Adding a stream binding to keep track of bucket being deleted
    criticalInfoChanged
        .bindStream(repository.criticalBucketInfoChanged(bucketModel.bucketId));
    // Listening to changes and deleting
    criticalInfoSub = criticalInfoChanged.listen((p0) {
      if (p0) {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "This bucket has been deleted!",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "Go back!",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Raleway'),
                          ),
                        ),
                        style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                Colors.white.withOpacity(0.15)),
                            backgroundColor: MaterialStateProperty.all(
                                ksecondaryBackgroundColor),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.black)))),
                        onPressed: () async {
                          Get.offNamedUntil('/home', (route) => false,
                              arguments: userModel);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ));
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    // entries.listen((p0) {
    //   print("READY : ${p0}");
    // });
  }

  @override
  void onClose() async {
    await criticalInfoSub.cancel();
  }
}
