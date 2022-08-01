import 'package:bucketlist/app/data/models/bucket_model.dart';
import 'package:bucketlist/app/data/models/user_model.dart';
import 'package:bucketlist/app/data/providers/realtime_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class UserRepository {
  addUser(UserModel userModel) async {
    await RealtimeDb.addUser(userModel);
  }

  getuser(String uid) async {
    return await RealtimeDb.getUser(uid);
  }

  checkUnique(String bucketId) async {
    return await RealtimeDb.checkUnique(bucketId);
  }

  registerBucket(UserModel userModel, String bucketId) async {
    return await RealtimeDb.registerBucket(userModel, bucketId);
  }

  userBucketStream(String uid) {
    var bucketSnapshots = RealtimeDb.getBuckets(uid);

    // Returning a STREAM of buckets to be listened to and bounded to the list in controller
    return bucketSnapshots.map((DatabaseEvent event) {
      List bucketEntries =
          List.from(Map.from(event.snapshot.value as Map).keys);
      // for (int i = 0; i < bucketEntries.length; i++) {
      //   var x = RealtimeDb.getBucketInfo(bucketEntries[i]);

      //   var t = x.map((DatabaseEvent test) {
      //     var userSnapshot = Map.of(test.snapshot.value as Map);
      //     BucketModel bucketModel =
      //         BucketModel.fromdataSnapshot(dataSnapshot: userSnapshot);
      //     return bucketModel;
      //   }).listen((event) {
      //     buckets.add(event);
      //   });
      // }
      return bucketEntries;
    });
  }

  bucketsStream(String userBucket) {
    var x = RealtimeDb.getBucketInfo(userBucket);

    return x.map((DatabaseEvent test) {
      List<BucketModel> temp = [];
      var userSnapshot = Map.of(test.snapshot.value as Map);
      BucketModel bucketModel =
          BucketModel.fromdataSnapshot(dataSnapshot: userSnapshot);
      temp.add(bucketModel);
      return temp;
    });
  }
}
