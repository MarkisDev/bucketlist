import 'package:bucketlist/app/data/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeDb {
  static final FirebaseDatabase _database = FirebaseDatabase.instance;

  static checkUnique(String bucketId) async {
    var snapshot = await _database.ref().child('buckets/${bucketId}').get();
    return snapshot.exists;
  }

  static checkUser(String uid) async {
    var snapshot = await _database.ref().child('users/${uid}').get();
    return snapshot.exists;
  }

  static addUser(UserModel userModel) async {
    await _database
        .ref('buckets/${userModel.bucketId}')
        .set({userModel.bucketId: true});
    await _database.ref("users/${userModel.id}").set({
      "name": userModel.fullName,
      "firstName": userModel.firstName,
      "lastName": userModel.lastName,
      "id": userModel.id,
      "photoUrl": userModel.photoUrl,
      "bucketId": userModel.bucketId,
    });
  }
}
