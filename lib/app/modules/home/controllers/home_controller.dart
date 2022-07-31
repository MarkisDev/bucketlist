import 'package:bucketlist/app/data/models/bucket_model.dart';
import 'package:bucketlist/app/data/repositories/user_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  var args = Get.arguments;
  final UserRepository repository;
  HomeController({required this.repository});
  final bucketList = [].obs;
  late var subscription;
  final bucketIdController = TextEditingController();
  @override
  void onInit() {
    super.onInit();

    // repository.userBucketStream(args.id).listen((z) {
    //   // print(z);
    //   userBucketList.assignAll(z);
    // });

    subscription = repository.bucketStream(args.id).listen((var x) {
      bucketList.bindStream(x);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    bucketIdController.dispose();
    subscription.cancel();
  }
}
