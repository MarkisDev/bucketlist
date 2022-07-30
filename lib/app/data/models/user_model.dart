import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserModel {
  late String fullName;
  late String firstName;
  late String lastName;
  late String email;
  late String id;
  late String photoUrl;
  late String bucketId;

  UserModel(
      {required this.fullName,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.id,
      required this.photoUrl,
      required this.bucketId});

  /// Constructor to init variables from Firebase
  UserModel.fromdataSnapshot({required Map dataSnapshot}) {
    fullName = dataSnapshot['fullName'];
    firstName = dataSnapshot['firstName'];
    lastName = dataSnapshot['lastName'];
    bucketId = dataSnapshot['bucketId'];
    photoUrl = dataSnapshot['photoUrl'];
    email = dataSnapshot['email'];
    id = dataSnapshot['id'];
  }
}
