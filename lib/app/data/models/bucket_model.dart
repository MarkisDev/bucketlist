import 'package:bucketlist/app/data/providers/firestore_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nanoid/async.dart';

class BucketModel {
  late Map creatorInfo;
  late List members;
  late Map timestamps;
  late Map numEntries;
  String? bucketId;
  late int totalEntries;
  late bool private;
  String? id;

  BucketModel(
      {required this.creatorInfo,
      required this.timestamps,
      required this.members,
      required this.numEntries,
      required this.bucketId,
      required this.totalEntries,
      required this.private});

  /// Constructor to init variables from Firebase
  BucketModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    creatorInfo = documentSnapshot['creatorInfo'];
    timestamps = documentSnapshot['timestamps'];
    members = documentSnapshot['members'];
    bucketId = documentSnapshot['bucketId'];
    totalEntries = documentSnapshot['totalEntries'];
    numEntries = documentSnapshot['numEntries'];
    private = documentSnapshot['private'];
    id = documentSnapshot.id;
  }

  static Map<String, dynamic> toMap(BucketModel bucketModel) {
    return {
      'numEntries': bucketModel.numEntries,
      'timestamps': bucketModel.timestamps,
      'creatorInfo': bucketModel.creatorInfo,
      'members': bucketModel.members,
      'bucketId': bucketModel.bucketId,
      'totalEntries': bucketModel.totalEntries,
      'private': bucketModel.private,
    };
  }

  static genId() async {
    String bucketId = await customAlphabet(
        "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", 5);
    bool res = await FirestoreDb.checkBucket(bucketId);
    if (res) {
      await genId();
    } else {
      return bucketId;
    }
  }
}
