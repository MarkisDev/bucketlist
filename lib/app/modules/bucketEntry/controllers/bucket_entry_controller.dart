import 'dart:convert';

import 'package:bucketlist/app/data/providers/realtime_provider.dart';
import 'package:bucketlist/app/data/repositories/bucket_repository.dart';
import 'package:bucketlist/app/modules/bucketInfo/controllers/bucket_info_controller.dart';
import 'package:bucketlist/app/ui/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:get/get.dart';

class BucketEntryController extends GetxController {
  BucketEntryController({required this.repository});
  final BucketRepository repository;
  late quill.QuillController quillController;
  var bucketController = Get.find<BucketInfoController>();
  final titleController = TextEditingController();
  final count = 0.obs;
  final bucketModel = Get.arguments['bucketModel'];
  final userModel = Get.arguments['userModel'];
  late final bucketData;
  @override
  void onInit() {
    // super.onInit();
    var bucketController = Get.find<BucketInfoController>();
    if (!bucketController.newEntry) {
      bucketData = Get.arguments['bucketData'];
      var document = jsonDecode(bucketData['entryInfo']['json']);
      titleController.text = bucketData['entryInfo']['title'];
      quillController = quill.QuillController(
          document: quill.Document.fromJson(document),
          selection: TextSelection.collapsed(offset: 0));
    } else {
      quillController = quill.QuillController.basic();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    if (!bucketController.newEntry) {
      var data = {
        "lock": false,
        "id": userModel.id,
        "fullName": userModel.fullName,
        "firstName": userModel.firstName,
        "lastName": userModel.lastName,
        "email": userModel.email,
      };
      repository.updateBucketMutex(
          bucketModel.bucketId, data, bucketData['entryId']);
    }
  }

  addOrUpdateBucketEntry() {
    var json = jsonEncode(quillController.document.toDelta().toJson());
    if (titleController.text.isEmpty) {
      Get.defaultDialog(
          title: "Error!",
          titlePadding: EdgeInsets.fromLTRB(0, 21, 0, 0),
          backgroundColor: kprimaryBackgroundColor,
          titleStyle: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500),
          contentPadding: EdgeInsets.all(21),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "Okay",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Raleway'),
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              ksecondaryBackgroundColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.black)))),
                      onPressed: () async {
                        Get.back();
                      },
                    ),
                  ],
                ),
              )
            ],
          ));
    } else {
      if (bucketController.newEntry) {
        var data = {
          "entryInfo": {
            "title": titleController.text,
            "json": json,
          },
          "creatorInfo": {
            "id": userModel.id,
            "fullName": userModel.fullName,
            "firstName": userModel.firstName,
            "lastName": userModel.lastName,
            "email": userModel.email,
          },
          "mutexInfo": {
            "lock": false,
            "id": userModel.id,
            "fullName": userModel.fullName,
            "firstName": userModel.firstName,
            "lastName": userModel.lastName,
            "email": userModel.email,
          },
        };
        RealtimeDb.addBucketEntry(bucketModel.bucketId, data, userModel.id);
        Get.snackbar(
          'Success!',
          'Added new entry!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: kprimaryColor,
          borderRadius: 20,
          margin: EdgeInsets.all(15),
          colorText: Colors.black,
          duration: Duration(seconds: 4),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeOutBack,
        );
      } else {
        var data = {
          "entryInfo": {
            "title": titleController.text,
            "json": json,
          },
          "mutexInfo": {
            "lock": false,
            "id": userModel.id,
            "fullName": userModel.fullName,
            "firstName": userModel.firstName,
            "lastName": userModel.lastName,
            "email": userModel.email,
          },
        };
        RealtimeDb.updateBucketEntry(
            bucketModel.bucketId, data, bucketData['entryId']);
        Get.snackbar(
          'Success!',
          'Updated new entry!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: kprimaryColor,
          borderRadius: 20,
          margin: EdgeInsets.all(15),
          colorText: Colors.black,
          duration: Duration(seconds: 4),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeOutBack,
        );
      }
    }
  }
}
