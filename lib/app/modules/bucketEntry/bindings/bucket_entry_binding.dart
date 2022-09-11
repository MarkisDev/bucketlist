import 'package:bucketlist/app/data/repositories/bucket_repository.dart';
import 'package:get/get.dart';

import '../controllers/bucket_entry_controller.dart';

class BucketEntryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BucketEntryController>(
      () => BucketEntryController(repository: BucketRepository()),
    );
  }
}
