import 'package:bucketlist/app/data/models/user_model.dart';
import 'package:bucketlist/app/data/providers/realtime_provider.dart';

class UserRepository {
  addUser(UserModel userModel) async {
    await RealtimeDb.addUser(userModel);
  }

  getuser(String uid) async {
    return await RealtimeDb.getUser(uid);
  }

  checkUnique(String bucketId) async {
    return await RealtimeDb.checkUnique(bucketId);
  }

  registerBucket(UserModel userModel, String bucketId) async {
    return await RealtimeDb.registerBucket(userModel, bucketId);
  }
}
