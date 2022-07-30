import 'package:bucketlist/app/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  var args = Get.arguments;
  final UserRepository repository;
  HomeController({required this.repository});

  final bucketIdController = TextEditingController();
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
