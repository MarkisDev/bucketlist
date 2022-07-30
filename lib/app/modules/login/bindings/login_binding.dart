import 'package:bucketlist/app/data/repositories/user_repository.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(repository: UserRepository()),
    );
  }
}
