import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

class BucketEntryController extends GetxController {
  QuillController quillController = QuillController.basic();
  final titleName = "".obs;
  final count = 0.obs;
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
    print(json);
    print(titleName);
  }
}
