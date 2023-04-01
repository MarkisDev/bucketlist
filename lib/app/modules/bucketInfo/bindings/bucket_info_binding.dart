import 'package:bucketlist/app/data/repositories/bucket_repository.dart';
import 'package:get/get.dart';

import '../controllers/bucket_info_controller.dart';

class BucketInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BucketInfoController>(
      () => BucketInfoController(),
    );
  }
}
