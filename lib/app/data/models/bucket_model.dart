class BucketModel {
  late Map creatorInfo;
  late Map members;
  String? bucketId;
  late int totalEntries;

  BucketModel(
      {required this.creatorInfo,
      required this.members,
      required this.bucketId,
      required this.totalEntries});

  /// Constructor to init variables from Firebase
  BucketModel.fromdataSnapshot({required Map dataSnapshot}) {
    creatorInfo = dataSnapshot['creatorInfo'];
    members = dataSnapshot['members'];
    bucketId = dataSnapshot['bucketId'];
    totalEntries = dataSnapshot['totalEntries'];
  }
}
