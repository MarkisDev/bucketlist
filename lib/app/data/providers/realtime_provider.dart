import 'dart:convert';

import 'package:bucketlist/app/data/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_list.dart';

class RealtimeDb {
  static final FirebaseDatabase _database = FirebaseDatabase.instance;

  static checkUnique(String bucketId) async {
    var snapshot = await _database.ref().child('buckets/${bucketId}').get();
    return snapshot.exists;
  }

  static checkUser(String uid) async {
    var snapshot = await _database.ref().child('users/${uid}').get();
    return snapshot;
  }

  static addUser(UserModel userModel) async {
    await _database
        .ref('buckets/${userModel.bucketId}')
        .set({"creatorId": userModel.id});
    await _database.ref("users/${userModel.id}").set({
      "fullName": userModel.fullName,
      "firstName": userModel.firstName,
      "lastName": userModel.lastName,
      "id": userModel.id,
      "photoUrl": userModel.photoUrl,
      "bucketId": userModel.bucketId,
      "email": userModel.email,
    });
  }

  static registerBucket(UserModel userModel, String bucketId) async {
    var bucketsRef = await _database.ref("users/${userModel.id}");
    bucketsRef.runTransaction((value) {
      Map<String, dynamic> _buckets = Map<String, dynamic>.from(value as Map);
      if (_buckets.containsKey('buckets')) {
        List<String> newBuckets =
            List<String>.from(_buckets['buckets'] as List);
        // Aborting transaction if user already part of bucket
        if (newBuckets.contains(bucketId)) {
          return Transaction.abort();
        } else {
          newBuckets.add(bucketId);
          _buckets['buckets'] = newBuckets;
        }
      } else {
        _buckets['buckets'] = [bucketId];
      }

      // Return the new data.
      return Transaction.success(_buckets);
    });
  }
}
