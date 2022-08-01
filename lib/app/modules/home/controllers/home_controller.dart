import 'dart:async';

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
  var bucketList = [].obs;
  final userBuckets = [].obs;
  final hackBucket = [].obs;

  final bucketIdController = TextEditingController();
  @override
  void onInit() {
    super.onInit();

    // Binding stream to userBuckets(because bind automatically updates the userBuckets list FULLY.) and then listening
    userBuckets.bindStream(repository.userBucketStream(args.id));
    // Listening to changes in userBuckets so we can fetch EACH BUCKET individually, then add to our bucketList.
    userBuckets.listen((p0) {
      // Since userBuckets returns a list of buckets, iterating through each bucket and using a small "hack" to bind it to the
      // observable hackBucket list. We could have made an observable bucketModel since bucketStream returns A list with SINGLE BucketModel
      for (var i in p0) {
        hackBucket.bindStream(repository.bucketsStream(i));
      }
    });

    // HackBucket will return a list with single element, it will change eachtime userBucket list changes.
    hackBucket.listen((p0) {
      if (bucketList.isNotEmpty) {
        // Addition to bucketList
        if (bucketList.length <= userBuckets.length) {
          // Checking if element NOT present in bucketList list

          if (!bucketList
              .any((element) => element.bucketId == p0[0].bucketId)) {
            // Checking if all the elements in bucketList is also present in userBucketList to perform remove!
            bucketList.add(p0[0]);
          }
        } else {
          // Element has been removed, checking which to update bucketList
          for (var bucket in bucketList) {
            if (!userBuckets.contains(bucket.bucketId)) {
              bucketList.removeWhere(
                  (element) => element.bucketId == bucket.bucketId);
              return;
            }
          }
        }
      } else {
        bucketList.add(p0[0]);
      }
    });
  }

  // for (final i in streams) {
  //   i.forEach((var x) {
  //     bucketList.addIf(bucketList.contains(x) == false, x);
  //   });

  // bucketList.bindStream(repository.bucketStream(args.id));
  // repository.bucketStream(args.id).listen((var x) {

  //   bucketList.assignAll(x);
  // });

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    bucketIdController.dispose();
    // subscription.cancel();
  }
}
