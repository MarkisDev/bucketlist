import 'package:bucketlist/app/data/providers/realtime_provider.dart';
import 'package:firebase_database/firebase_database.dart';

class BucketRepository {
  deleteBucketEntry(String bucketId, String entryId, String userId) async {
    await RealtimeDb.deleteBucketEntry(bucketId, entryId, userId);
  }

  getBucketEntries(String bucketId) {
    var bucketSnapshot = RealtimeDb.getBucketInfo(bucketId);
    return bucketSnapshot.map((DatabaseEvent event) {
      List entries = [];

      Map bucket = Map.of(event.snapshot.value as Map);
      if (bucket.containsKey('entries') && bucket['entries'].length > 0) {
        for (final key in bucket['entries'].keys) {
          Map data = bucket['entries'][key];
          data['entryId'] = key;
          entries.add(bucket['entries'][key]);
        }
      }
      return entries;
    });
  }

  addBucketEntry(String bucketId, Map data, String userId) {
    RealtimeDb.addBucketEntry(bucketId, data, userId);
  }

  updateBucketEntry(String bucketId, Map data, String entryId) {
    RealtimeDb.updateBucketEntry(bucketId, data, entryId);
  }

  updateBucketMutex(String bucketId, Map data, String entryId) {
    RealtimeDb.updateBucketMutex(bucketId, data, entryId);
  }
}
