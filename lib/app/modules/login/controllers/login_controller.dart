import 'package:bucketlist/app/data/models/user_model.dart';
import 'package:bucketlist/app/data/providers/realtime_provider.dart';
import 'package:bucketlist/app/data/repositories/user_repository.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nanoid/async.dart';

class LoginController extends GetxController {
  final UserRepository repository;
  LoginController({required this.repository});
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late UserModel userModel;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  // Generates a 7-letter unique key
  genUniqueId() async {
    String bucketId = await nanoid(7);
    bool res = await RealtimeDb.checkUnique(bucketId);
    if (res) {
      await genUniqueId();
    } else {
      return bucketId;
    }
  }

  // Logins user using GoogleSignIn
  loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      String fullName = googleSignInAccount!.displayName.toString();
      List<String> parts = fullName.split(" ");
      String lastName = " ";
      if (parts.length == 3) {
        if (parts[parts.length - 1].length == 1) {
          lastName = parts[1];
        } else {
          lastName = parts[parts.length - 1];
        }
      } else {
        lastName = parts[parts.length - 1];
      }
      String firstName = parts[0];

      String bucketId;

      if (await repository.checkUser(googleSignInAccount.id)) {
        userModel = UserModel(
            fullName: fullName,
            firstName: firstName,
            lastName: lastName,
            email: googleSignInAccount.email,
            id: googleSignInAccount.id,
            photoUrl: googleSignInAccount.photoUrl.toString(),
            bucketId: 'Ayy');
      }
      var x = await repository.addUser(userModel);
      await Get.offNamed('/home', arguments: userModel);
      return;
    } catch (e) {
      throw (e);
    }
  }

  /// Logs user out
  Future<void> logoutGoogle() async {
    await _googleSignIn.signOut();
    Get.offAllNamed('/');
  }
}
