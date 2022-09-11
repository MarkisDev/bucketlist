import 'package:bucketlist/app/data/models/bucket_model.dart';
import 'package:bucketlist/app/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeDb {
  static final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Check if bucket exists
  static checkBucket(String bucketId) async {
    var snapshot = await _database.ref().child('buckets/${bucketId}').get();
    return snapshot.exists;
  }

  static checkBucketPrivate(String bucketId) async {
    var snapshot =
        await _database.ref().child('buckets/${bucketId}/private').get();
    return snapshot.value;
  }

  static checkUserBucketId(String userId, String bucketId) async {
    var snapshot =
        await _database.ref().child('users/${userId}/bucketId').get();
    if (snapshot.value == bucketId) {
      return true;
    } else {
      return false;
    }
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
      "email": userModel.email
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

  static addBucketEntry(String bucketId, Map data, String userId) async {
    // Update entries in user buckets

    await _database
        .ref("users/${userId}/buckets/${bucketId}")
        .runTransaction((var value) {
      int x = value as int;
      x += 1;

      return Transaction.success(x);
    });

    // Update entries in buckets
    await _database
        .ref("buckets/${bucketId}/totalEntries")
        .runTransaction((var value) {
      int x = value as int;
      x += 1;

      return Transaction.success(x);
    });

    await _database
        .ref("buckets/${bucketId}/members/${userId}/numberEntries")
        .runTransaction((var value) {
      int x = value as int;
      x += 1;

      return Transaction.success(x);
    });
    // Add entry to db
    await _database.ref("buckets/${bucketId}/entries").push().set(data);
  }

  static updateBucketEntry(String bucketId, Map data, String entryId) {
    return _database.ref('buckets/${bucketId}/entries/${entryId}').update(
        {'mutexInfo': data['mutexInfo'], 'entryInfo': data['entryInfo']});
  }

  static updateBucketMutex(String bucketId, Map data, String entryId) {
    return _database
        .ref('buckets/${bucketId}/entries/${entryId}')
        .update({'mutexInfo': data});
  }

  static deleteBucketEntry(
      String bucketId, String entryId, String userId) async {
    await _database
        .ref("users/${userId}/buckets/${bucketId}")
        .runTransaction((var value) {
      int x = value as int;
      x -= 1;

      return Transaction.success(x);
    });

    // Update entries in buckets
    await _database
        .ref("buckets/${bucketId}/totalEntries")
        .runTransaction((var value) {
      int x = value as int;
      x -= 1;

      return Transaction.success(x);
    });

    await _database
        .ref("buckets/${bucketId}/members/${userId}/numberEntries")
        .runTransaction((var value) {
      int x = value as int;
      x -= 1;

      return Transaction.success(x);
    });

    return _database.ref('buckets/${bucketId}/entries/$entryId').remove();
  }

  static deleteBucket(String bucketId) async {
    // Getting members from bucket and converting to a list
    var memberInfoSnapshot =
        await _database.ref("buckets/${bucketId}/members").get();
    List memberEntries =
        List.from(Map.from(memberInfoSnapshot.value as Map).keys);
    // Deleting bucket from each member
    for (var userId in memberEntries) {
      _database.ref('users/${userId}/buckets/${bucketId}').remove();
    }

    _database.ref('buckets/${bucketId}').remove();
  }

  static Stream<DatabaseEvent> getBucketEntries(String bucketId) {
    return _database.ref("buckets/${bucketId}/entries").onValue;
  }

  static Stream<DatabaseEvent> getBuckets(String uid) {
    return _database.ref("users/${uid}/buckets").onValue;
  }

  static Stream<DatabaseEvent> getBucketInfo(String bucketId) {
    return _database.ref("buckets/${bucketId}").onValue;
  }
}
