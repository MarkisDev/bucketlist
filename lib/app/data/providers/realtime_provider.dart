import 'package:bucketlist/app/data/models/bucket_model.dart';
import 'package:bucketlist/app/data/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeDb {
  static final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Check if bucket exists
  static checkBucket(String bucketId) async {
    var snapshot = await _database.ref().child('buckets/${bucketId}').get();
    return snapshot.exists;
  }

  static getUser(String uid) async {
    var snapshot = await _database.ref().child('users/${uid}').get();
    return snapshot;
  }

  static addBucket(BucketModel bucketModel) async {
    await _database.ref('buckets/${bucketModel.bucketId}').set({
      "creatorInfo": bucketModel.creatorInfo,
      "bucketId": bucketModel.bucketId,
      "members": bucketModel.members,
      "totalEntries": bucketModel.totalEntries,
      "timestamp": DateTime.now().toUtc().toIso8601String(),
      "private": bucketModel.private,
      "timestamp": DateTime.now().toUtc().toIso8601String()
    });
    // Making this for future updates
    return true;
  }

  static addUser(UserModel userModel) async {
    // Adding bucket
    BucketModel bucketModel = BucketModel(creatorInfo: {
      "id": userModel.id,
      "fullName": userModel.fullName,
      "firstName": userModel.firstName,
      "lastName": userModel.lastName,
    }, members: {
      userModel.id: {
        "timestamp": DateTime.now().toUtc().toIso8601String(),
        "entries": 0,
        "fullName": userModel.fullName,
        "firstName": userModel.firstName,
        "lastName": userModel.lastName,
      },
    }, bucketId: userModel.bucketId, totalEntries: 0, private: true);

    await addBucket(bucketModel);

    await _database.ref("users/${userModel.id}").set({
      "fullName": userModel.fullName,
      "firstName": userModel.firstName,
      "lastName": userModel.lastName,
      "id": userModel.id,
      "photoUrl": userModel.photoUrl,
      "bucketId": userModel.bucketId,
      "email": userModel.email,
      "buckets": {userModel.bucketId: 0},
    });
  }

  static registerBucket(UserModel userModel, String bucketId) async {
    var bucketsRefCurrentUser = _database.ref("users/${userModel.id}/buckets");
    var userBucketsSnap = await bucketsRefCurrentUser.child(bucketId).get();
    // Adding bucketId to user and User to bucket memebers. one-to-one.
    if (!userBucketsSnap.exists) {
      // Adding for user

      await bucketsRefCurrentUser.update({bucketId: 0});
      await _database.ref("buckets/${bucketId}/members").update({
        userModel.id: {
          "fullName": userModel.fullName,
          "numberEntries": 0,
          "timestamp": DateTime.now().toUtc().toIso8601String(),
        }
      });
      return true;
    } else {
      // User already part of bucket
      return false;
    }
  }

  static Stream<DatabaseEvent> getBuckets(String uid) {
    return _database.ref("users/${uid}/buckets").onValue;
  }

  static Stream<DatabaseEvent> getBucketInfo(String bucketId) {
    return _database.ref("buckets/${bucketId}").onValue;
  }
}
