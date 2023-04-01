import 'package:cloud_firestore/cloud_firestore.dart';

class BucketEntriesModel {
  late Map entryInfo;
  late Map mutexInfo;
  String? id;
  Map? creatorInfo;

  BucketEntriesModel(
      {required this.entryInfo, required this.mutexInfo, this.creatorInfo});

  BucketEntriesModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    entryInfo = documentSnapshot['entryInfo'];
    mutexInfo = documentSnapshot['mutexInfo'];
    creatorInfo = documentSnapshot['creatorInfo'];
    id = documentSnapshot.id;
  }

  static Map<String, dynamic> toMap(BucketEntriesModel bucketModel) {
    return {
      'entryInfo': bucketModel.entryInfo,
      'mutexInfo': bucketModel.mutexInfo,
      'creatorInfo': bucketModel.creatorInfo,
    };
  }
}
