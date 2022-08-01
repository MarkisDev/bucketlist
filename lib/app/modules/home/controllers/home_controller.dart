import 'dart:async';

import 'package:bucketlist/app/data/models/bucket_model.dart';
import 'package:bucketlist/app/data/repositories/user_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var args = Get.arguments;
  final UserRepository repository;
  HomeController({required this.repository});
  var bucketList = [].obs;
  var streams = [].obs;
  var activeStreams = [].obs;
  final bucketIdController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    // Binding to a streams list which holds a stream instance for each bucket.
    // bucketsStream returns a list of stream for each bucket. Since we're using bind, we are mapping and returning the stream. check func.
    streams.bindStream(repository.bucketStream(args.id));
    // Listening to changes in the total streams (addition/deletion of buckets)
    streams.listen((List userBucketsStream) {
      // Iterating through list and listening to each bucket.
      userBucketsStream.forEach((bucketStream) {
        StreamSubscription x = bucketStream.listen(
          (bucket) {
            // Checking if an item was REMOVED from the bucket, if yes then fully clearing it and then adding everything again.
            if (bucketList.length > userBucketsStream.length) {
              bucketList.clear();
            }
            // Checking if the element that's being added is not in the list, then adding it.
            if (!bucketList
                .any((element) => element.bucketId == bucket.bucketId)) {
              bucketList.add(bucket);
            } else {
              // So the element in list actually exists...but here's the big brain! Since we have a listener for EACH bucket in the userBuckets
              // A listener is telling us ONE bucket was changed, so we're changing that bucket :) (TOTAL ENTRIES!)
              // Wish dart had replaceFunc (sigh)
              var index = bucketList
                  .indexWhere((element) => element.bucketId == bucket.bucketId);
              bucketList.removeAt(index);
              bucketList.insert(index, bucket);
            }
          },
        );
        activeStreams.add(x);
      });
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() async {
    bucketIdController.dispose();
    // Okay, gotta close all those streamSubscriptions :D
    for (var stream in activeStreams) {
      await stream.cancel();
    }
  }
}
