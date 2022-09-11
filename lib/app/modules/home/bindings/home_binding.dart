import 'package:bucketlist/app/data/repositories/user_repository.dart';
import 'package:bucketlist/app/modules/login/controllers/login_controller.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(repository: UserRepository()),
    );
    Get.lazyPut<LoginController>(
      () => LoginController(repository: UserRepository()),
    );
  }
}
