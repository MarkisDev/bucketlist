import 'package:bucketlist/app/data/models/bucket_model.dart';
import 'package:bucketlist/app/data/models/user_model.dart';
import 'package:bucketlist/app/data/providers/realtime_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class UserRepository {
  addUser(UserModel userModel) async {
    await RealtimeDb.addUser(userModel);
  }

  addBucket(BucketModel bucketModel) async {
    return await RealtimeDb.addBucket(bucketModel);
  }

  getuser(String uid) async {
    return await RealtimeDb.getUser(uid);
  }

  checkBucket(String bucketId) async {
    return await RealtimeDb.checkBucket(bucketId);
  }

  registerBucket(UserModel userModel, String bucketId) async {
    return await RealtimeDb.registerBucket(userModel, bucketId);
  }

  bucketStream(String uid) {
    var bucketSnapshots = RealtimeDb.getBuckets(uid);

    return bucketSnapshots.map((DatabaseEvent event) {
      List temp = [];
      List bucketEntries =
          List.from(Map.from(event.snapshot.value as Map).keys);

      for (var userBucket in bucketEntries) {
        var x = RealtimeDb.getBucketInfo(userBucket);
        var t = x.map((DatabaseEvent test) {
          var userSnapshot = Map.of(test.snapshot.value as Map);
          BucketModel bucketModel =
              BucketModel.fromdataSnapshot(dataSnapshot: userSnapshot);
          return bucketModel;
        });
        temp.add(t);
      }
      return temp;
    });
  }
}
