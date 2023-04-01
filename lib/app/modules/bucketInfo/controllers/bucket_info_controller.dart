import 'dart:async';

import 'package:bucketlist/app/data/models/bucket_entries_model.dart';
import 'package:bucketlist/app/data/models/bucket_model.dart';
import 'package:bucketlist/app/data/models/user_model.dart';
import 'package:bucketlist/app/data/providers/firestore_provider.dart';
import 'package:bucketlist/app/data/providers/realtime_provider.dart';
import 'package:bucketlist/app/data/repositories/bucket_repository.dart';
import 'package:bucketlist/app/data/repositories/user_repository.dart';
import 'package:bucketlist/app/modules/home/controllers/home_controller.dart';
import 'package:bucketlist/app/ui/theme/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BucketInfoController extends GetxController {
  BucketModel bucketModel = Get.arguments;
  late final UserModel userModel;
  var newEntry = true;
  final entries = <BucketEntriesModel>[].obs;
  // var criticalInfoChanged = false.obs;
  late Stream<DocumentSnapshot> bucketStream;
  late StreamSubscription bucketStreamSub;

  @override
  void onInit() async {
    super.onInit();

    HomeController homeController = Get.find<HomeController>();
    userModel = homeController.args;

    bucketStream = await FirestoreDb.getBucketStream(bucketModel.id!);
    // Listening to bucket to ensure that bucket isn't deleted when it is open
    // Ideally won't happen on one phone, but if logged in same account using two phones this can arise
    bucketStreamSub = bucketStream.listen((DocumentSnapshot docSnap) {
      if (!docSnap.exists) {
        Get.defaultDialog(
            title: "Error!",
            titlePadding: const EdgeInsets.fromLTRB(0, 21, 0, 0),
            backgroundColor: kprimaryColor,
            titleStyle: const TextStyle(
                color: Colors.black,
                fontSize: 23,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500),
            contentPadding: const EdgeInsets.all(21),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
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
                        style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                Colors.white.withOpacity(0.15)),
                            backgroundColor: MaterialStateProperty.all(
                                ksecondaryBackgroundColor),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(
                                        color: Colors.black)))),
                        onPressed: () async {
                          Get.offNamedUntil('/home', (route) => false,
                              arguments: userModel);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "Go back!",
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
        // Always storing latest copy of bucket to fetch entries
        bucketModel =
            BucketModel.fromDocumentSnapshot(documentSnapshot: docSnap);
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() async {
    await bucketStreamSub.cancel();
  }
}
