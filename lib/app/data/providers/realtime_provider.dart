import 'package:bucketlist/app/data/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeDb {
  static final DatabaseReference _database = FirebaseDatabase.instance.ref();

  static addUser(UserModel userModel, String uid) async {
    await _database.set({
      "name": userModel.fullName,
      "firstName": userModel.fullName,
      "lastName": userModel.lastName,
      "id": userModel.id,
      "photoUrl": userModel.photoUrl
    });
  }
}
