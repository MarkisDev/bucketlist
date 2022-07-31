import 'package:bucketlist/app/data/models/bucket_model.dart';
import 'package:bucketlist/app/data/models/user_model.dart';
import 'package:bucketlist/app/data/providers/realtime_provider.dart';
import 'package:firebase_database/firebase_database.dart';

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

  bucketStream(String uid) {
    var bucketSnapshots = RealtimeDb.getBuckets(uid);
    List<BucketModel> buckets = [];
    // Returning a STREAM of buckets to be listened to and bounded to the list in controller
    return bucketSnapshots.map((DatabaseEvent event) {
      List bucketEntries =
          List.from(Map.from(event.snapshot.value as Map).keys);
      for (var bucketId in bucketEntries) {
        var x = RealtimeDb.getBucketInfo(bucketId);
        return x.map((DatabaseEvent test) {
          var userSnapshot = Map.of(test.snapshot.value as Map);
          BucketModel bucketModel =
              BucketModel.fromdataSnapshot(dataSnapshot: userSnapshot);
          buckets.add(bucketModel);
          return buckets;
        });
      }
    });
  }
}
