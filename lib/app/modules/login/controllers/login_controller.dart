import 'package:bucketlist/app/data/models/bucket_model.dart';
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
  late GoogleSignInAccount? googleSignInAccount;
  @override
  void onInit() async {
    super.onInit();
    if (await _googleSignIn.isSignedIn()) {
      googleSignInAccount = await _googleSignIn.signInSilently();
      moveToHome();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  loginWithGoogle() async {
    try {
      googleSignInAccount = await _googleSignIn.signIn();
      moveToHome();
    } catch (e) {
      print(e);
    }
  }

  // Logins user using GoogleSignIn
  moveToHome() async {
    try {
      String fullName = googleSignInAccount!.displayName.toString();
      List<String> parts = fullName.split(" ");
      String lastName = " ";
      if (parts.length == 3) {
        if (parts[parts.length - 1].length == 1) {
          lastName = parts[1].toLowerCase().capitalizeFirst.toString();
        } else {
          lastName =
              parts[parts.length - 1].toLowerCase().capitalizeFirst.toString();
        }
      } else {
        lastName =
            parts[parts.length - 1].toLowerCase().capitalizeFirst.toString();
      }
      String firstName = parts[0].toLowerCase().capitalizeFirst.toString();

      var userSnapshot = await repository.getuser(googleSignInAccount!.id);

      if (!userSnapshot.exists) {
        String bucketId = await BucketModel.genId();
        userModel = UserModel(
            fullName: fullName,
            firstName: firstName,
            lastName: lastName,
            email: googleSignInAccount!.email,
            id: googleSignInAccount!.id,
            photoUrl: googleSignInAccount!.photoUrl.toString(),
            bucketId: bucketId);
        await repository.addUser(userModel);
      } else {
        userModel =
            UserModel.fromdataSnapshot(dataSnapshot: userSnapshot.value);
      }

      await Get.offNamed('/home', arguments: userModel);
    } catch (e) {
      throw (e);
    }
  }

  /// Logs user out
  Future<void> logoutGoogle() async {
    await _googleSignIn.signOut();
    Get.offAllNamed('/login');
  }
}
