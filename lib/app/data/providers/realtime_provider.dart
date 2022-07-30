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

  static getUser(String uid) async {
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
    var bucketsRef = _database.ref("users/${userModel.id}/buckets");
    var userBucketsSnap = await bucketsRef.child(bucketId).get();
    if (!userBucketsSnap.exists) {
      await bucketsRef.update({bucketId: 0});
      await _database
          .ref("buckets/${bucketId}/members")
          .update({userModel.id: 0});
    }
  }
}
