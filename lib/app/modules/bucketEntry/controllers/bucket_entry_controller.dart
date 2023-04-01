import 'dart:async';
import 'dart:convert';

import 'package:bucketlist/app/data/models/bucket_entries_model.dart';
import 'package:bucketlist/app/data/models/bucket_model.dart';
import 'package:bucketlist/app/data/models/user_model.dart';
import 'package:bucketlist/app/data/providers/firestore_provider.dart';
import 'package:bucketlist/app/modules/bucketInfo/controllers/bucket_info_controller.dart';
import 'package:bucketlist/app/ui/theme/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:get/get.dart';

class BucketEntryController extends GetxController {
  late quill.QuillController quillController;
  var bucketController = Get.find<BucketInfoController>();
  final titleController = TextEditingController();
  BucketModel bucketModel = Get.arguments['bucketModel'];
  final UserModel userModel = Get.arguments['userModel'];
  late final BucketEntriesModel bucketData;
  late Stream<DocumentSnapshot> bucketStream;
  late StreamSubscription bucketStreamSub;

  addOrUpdateBucketEntry() async {
    var json = jsonEncode(quillController.document.toDelta().toJson());
    if (titleController.text.isEmpty) {
      Get.defaultDialog(
          title: "Error!",
          titlePadding: const EdgeInsets.fromLTRB(0, 21, 0, 0),
          backgroundColor: kprimaryBackgroundColor,
          titleStyle: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500),
          contentPadding: const EdgeInsets.all(21),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Please enter a title to save!",
                style: TextStyle(
                    color: Colors.white,
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: const BorderSide(
                                          color: Colors.black)))),
                      onPressed: () async {
                        Get.back();
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "Okay",
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
      var data = {
        "entryInfo": {
          "title": titleController.text,
          "json": json,
        },
        "mutexInfo": {
          "lock": true,
          "id": userModel.id,
          "fullName": userModel.fullName,
          "firstName": userModel.firstName,
          "lastName": userModel.lastName,
          "email": userModel.email,
          "timestamp": DateTime.now().toUtc().toIso8601String(),
        },
      };
      if (bucketController.newEntry == false) {
        Get.snackbar(
          'Success!',
          'Updated new entry!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: kprimaryColor,
          borderRadius: 20,
          margin: const EdgeInsets.all(15),
          colorText: Colors.black,
          duration: const Duration(seconds: 4),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeOutBack,
        );
        // Updating exisitng bucket
        await FirestoreDb.updateBucketEntry(
            bucketModel.id!, data, bucketData.id!);
      } else {
        // Adding creator info for new entry
        data['creatorInfo'] = {
          "id": userModel.id,
          "fullName": userModel.fullName,
          "firstName": userModel.firstName,
          "lastName": userModel.lastName,
          "email": userModel.email,
          "timestamp": DateTime.now().toUtc().toIso8601String(),
        };

        Get.snackbar(
          'Success!',
          'Added new entry!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: kprimaryColor,
          borderRadius: 20,
          margin: const EdgeInsets.all(15),
          colorText: Colors.black,
          duration: const Duration(seconds: 4),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeOutBack,
        );

        String entryDocId = await FirestoreDb.addBucketEntry(
            userModel.id, bucketModel.id!, data);
        bucketData =
            await FirestoreDb.getBucketEntry(bucketModel.id!, entryDocId);
      }
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();

    var bucketController = Get.find<BucketInfoController>();
    if (!bucketController.newEntry) {
      bucketData = Get.arguments['bucketData'];
      var document = jsonDecode(bucketData.entryInfo['json']);
      titleController.text = bucketData.entryInfo['title'];
      quillController = quill.QuillController(
          document: quill.Document.fromJson(document),
          selection: const TextSelection.collapsed(offset: 0));
    } else {
      quillController = quill.QuillController.basic();
    }

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
                          Get.toNamed('/home', arguments: userModel);
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
        // Always storing latest copy of bucket
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

    var mutex = {
      "lock": false,
      "id": userModel.id,
      "fullName": userModel.fullName,
      "firstName": userModel.firstName,
      "lastName": userModel.lastName,
      "email": userModel.email,
      "timestamp": DateTime.now().toUtc().toIso8601String(),
    };
    await FirestoreDb.updateMutex(bucketModel.id!, bucketData.id!, mutex);
  }
}
