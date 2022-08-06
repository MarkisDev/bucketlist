import 'package:bucketlist/app/data/providers/realtime_provider.dart';
import 'package:nanoid/async.dart';

class BucketModel {
  late Map creatorInfo;
  late Map members;
  String? bucketId;
  late int totalEntries;
  late bool private;

  BucketModel(
      {required this.creatorInfo,
      required this.members,
      required this.bucketId,
      required this.totalEntries,
      required this.private});

  /// Constructor to init variables from Firebase
  BucketModel.fromdataSnapshot({required Map dataSnapshot}) {
    creatorInfo = dataSnapshot['creatorInfo'];
    members = dataSnapshot['members'];
    bucketId = dataSnapshot['bucketId'];
    totalEntries = dataSnapshot['totalEntries'];
    private = dataSnapshot['private'];
  }

  static genId() async {
    String bucketId = await customAlphabet(
        "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", 5);
    bool res = await RealtimeDb.checkBucket(bucketId);
    if (res) {
      await genId();
    } else {
      return bucketId;
    }
  }
}
