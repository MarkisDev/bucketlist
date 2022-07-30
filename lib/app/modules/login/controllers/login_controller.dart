import 'package:bucketlist/app/data/models/user_model.dart';
import 'package:bucketlist/app/data/providers/realtime_provider.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
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

      userModel = UserModel(
          fullName: fullName,
          firstName: firstName,
          lastName: lastName,
          email: googleSignInAccount.email,
          id: googleSignInAccount.id,
          photoUrl: googleSignInAccount.photoUrl.toString());

      var x = await RealtimeDb.addUser(userModel, googleSignInAccount.id);
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
