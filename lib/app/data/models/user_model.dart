import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  UserModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    fullName = documentSnapshot['fullName'];
    firstName = documentSnapshot['firstName'];
    lastName = documentSnapshot['lastName'];
    bucketId = documentSnapshot['bucketId'];
    photoUrl = documentSnapshot['photoUrl'];
    email = documentSnapshot['email'];
    id = documentSnapshot['id'];
  }
  static Map<String, dynamic> toMap(UserModel userModel) {
    return {
      "fullName": userModel.fullName,
      "firstName": userModel.firstName,
      "lastName": userModel.lastName,
      "id": userModel.id,
      "photoUrl": userModel.photoUrl,
      "bucketId": userModel.bucketId,
      "email": userModel.email,
    };
  }
}
