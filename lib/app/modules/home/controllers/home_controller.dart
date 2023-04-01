import 'dart:async';

import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:bucketlist/app/data/models/bucket_model.dart';
import 'package:bucketlist/app/data/repositories/user_repository.dart';
import 'package:bucketlist/app/modules/login/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  BucketModel? checkBucket;
  var args = Get.arguments;
  var bucketList = [].obs;
  final newBucketId = "".obs;
  final bucketIdController = TextEditingController();
  // final GlobalKey<AnimatedFloatingActionButtonState> FabKey =
  //     GlobalKey<AnimatedFloatingActionButtonState>();
  final LoginController loginController = Get.find<LoginController>();
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
    bucketIdController.dispose();
  }
}
