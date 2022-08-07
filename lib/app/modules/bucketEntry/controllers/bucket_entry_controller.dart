import 'dart:convert';

import 'package:bucketlist/app/data/providers/realtime_provider.dart';
import 'package:bucketlist/app/modules/bucketInfo/controllers/bucket_info_controller.dart';
import 'package:bucketlist/app/ui/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

class BucketEntryController extends GetxController {
  late QuillController quillController;
  final titleController = TextEditingController();
  final count = 0.obs;
  final bucketModel = Get.arguments['bucketModel'];
  final userModel = Get.arguments['userModel'];
  late final bucketData;
  @override
  void onInit() {
    super.onInit();
    var bucketController = Get.find<BucketInfoController>();
    if (!bucketController.newEntry) {
      bucketData = Get.arguments['bucketData'];
      var document = jsonDecode(bucketData['json']);
      titleController.text = bucketData['title'];
      quillController = QuillController(
          document: Document.fromJson(document),
          selection: TextSelection.collapsed(offset: 0));
    } else {
      quillController = QuillController.basic();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    var bucketController = Get.find<BucketInfoController>();

    var json = jsonEncode(quillController.document.toDelta().toJson());
    var data = {
      "title": titleController.text,
      "json": json,
      "creatorInfo": {
        "id": userModel.id,
        "fullName": userModel.fullName,
        "firstName": userModel.firstName,
        "lastName": userModel.lastName,
        "email": userModel.email,
      }
    };
    if (bucketController.newEntry) {
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
