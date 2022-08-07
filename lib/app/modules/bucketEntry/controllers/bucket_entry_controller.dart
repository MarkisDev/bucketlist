import 'dart:convert';

import 'package:bucketlist/app/data/providers/realtime_provider.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

class BucketEntryController extends GetxController {
  QuillController quillController = QuillController.basic();
  final titleName = "".obs;
  final count = 0.obs;
  final bucketModel = Get.arguments['bucketModel'];
  final userModel = Get.arguments['userModel'];
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    var json = jsonEncode(quillController.document.toDelta().toJson());
    var data = {
      "title": titleName.value,
      "json": json,
      "creatorInfo": {
        "id": userModel.id,
        "fullName": userModel.fullName,
        "firstName": userModel.firstName,
        "lastName": userModel.lastName,
        "email": userModel.email,
      }
    };
    RealtimeDb.addBucketEntry(bucketModel.bucketId, data);
  }
}
