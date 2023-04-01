import 'package:bucketlist/app/data/models/bucket_entries_model.dart';
import 'package:bucketlist/app/data/models/bucket_model.dart';
import 'package:bucketlist/app/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDb {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;
  static final CollectionReference _usersCollection =
      _firebaseFirestore.collection('users');
  static final CollectionReference _bucketsCollection =
      _firebaseFirestore.collection('buckets');

  static Future<bool> checkBucket(String bucketId) async {
    final query =
        _bucketsCollection.where('bucketId', isEqualTo: bucketId).limit(1);
    final docs = await query.get();
    return docs.docs.isNotEmpty;
  }

  static getBucket(String bucketId) async {
    return await _bucketsCollection
        .where('bucketId', isEqualTo: bucketId)
        .get();
  }

  static getBucketStream(String documentId) async {
    return _bucketsCollection.doc(documentId).snapshots();
  }

  static getBucketEntriesStream(String documentId) async {
    return _bucketsCollection.doc(documentId).snapshots();
  }

  static getUser(String userId) async {
    return await _usersCollection.doc(userId).get();
  }

  static getBucketEntry(String bucketDocId, String entryDocId) async {
    DocumentSnapshot doc = await _bucketsCollection
        .doc(bucketDocId)
        .collection('entries')
        .doc(entryDocId)
        .get();

    return BucketEntriesModel.fromDocumentSnapshot(documentSnapshot: doc);
  }

  static addBucket(UserModel userModel, BucketModel bucketModel) async {
    await _bucketsCollection.add(BucketModel.toMap(bucketModel));
    return true;
  }

  static addMember(String documentId, String userId) async {
    await _bucketsCollection.doc(documentId).update({
      'members': FieldValue.arrayUnion([userId]),
      'timestamp.${userId}': DateTime.now().toUtc().toIso8601String(),
      'entries.${userId}': 0
    });
  }

  static addUser(UserModel userModel) {
    BucketModel bucketModel = BucketModel(
        creatorInfo: UserModel.toMap(userModel),
        members: [
          userModel.id,
        ],
        timestamps: {userModel.id: DateTime.now().toUtc().toIso8601String()},
        numEntries: {userModel.id: 0},
        bucketId: userModel.bucketId,
        totalEntries: 0,
        private: true);
    // Adding private bucket
    addBucket(userModel, bucketModel);
    _usersCollection.doc(userModel.id).set(UserModel.toMap(userModel));
  }

  static getBuckets(UserModel userModel) {
    return _bucketsCollection
        .where('members', arrayContains: userModel.id)
        .snapshots();
  }

  static deleteBucketEntry(
      String userId, String bucketDocId, String entryDocId) async {
    await _bucketsCollection.doc(bucketDocId).update({
      'totalEntries': FieldValue.increment(-1),
      'numEntries.$userId': FieldValue.increment(-1)
    });
    return await _bucketsCollection
        .doc(bucketDocId)
        .collection('entries')
        .doc(entryDocId)
        .delete();
  }

  static removeMember(String documentId, String userId) async {
    // Removing member
    await _bucketsCollection.doc(documentId).update({
      'members': FieldValue.arrayRemove([userId]),
      'entries.${userId}': FieldValue.delete()
    });

    // Deleting bucket document if no members exist
    DocumentSnapshot doc = await _bucketsCollection.doc(documentId).get();
    BucketModel bucketModel =
        BucketModel.fromDocumentSnapshot(documentSnapshot: doc);
    if (bucketModel.members.isEmpty) {
      if (bucketModel.totalEntries >= 1) {
        // Deleting all entries also
        QuerySnapshot query = await _bucketsCollection
            .doc(documentId)
            .collection('entries')
            .get();
        for (DocumentSnapshot doc in query.docs) {
          await doc.reference.delete();
        }
      }
      await _bucketsCollection.doc(documentId).delete();
    }
  }

  static getBucketEntries(String bucketDocId) {
    return _bucketsCollection
        .doc(bucketDocId)
        .collection('entries')
        .snapshots();
  }

  static addBucketEntry(
      String userId, String bucketDocId, Map<String, dynamic> entryData) async {
    DocumentReference docRef =
        _bucketsCollection.doc(bucketDocId).collection('entries').doc();
    await docRef.set(entryData);

    await _bucketsCollection.doc(bucketDocId).update({
      'numEntries.$userId': FieldValue.increment(1),
      'totalEntries': FieldValue.increment(1),
    });
    return docRef.id;
  }

  static updateBucketEntry(String bucketDocId, Map<String, dynamic> entryData,
      String entryDocId) async {
    return await _bucketsCollection
        .doc(bucketDocId)
        .collection('entries')
        .doc(entryDocId)
        .update(entryData);
  }

  static updateMutex(
      String bucketDocId, String entryDocId, Map mutexData) async {
    return await _bucketsCollection
        .doc(bucketDocId)
        .collection('entries')
        .doc(entryDocId)
        .update({'mutexInfo': mutexData});
  }
}
