import 'package:bucketlist/app/data/models/user_model.dart';
import 'package:bucketlist/app/data/providers/realtime_provider.dart';
import 'package:bucketlist/app/data/repositories/bucket_repository.dart';
import 'package:bucketlist/app/data/repositories/user_repository.dart';
import 'package:bucketlist/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';

class BucketInfoController extends GetxController {
  var bucketModel = Get.arguments;
  final BucketRepository repository;
  late final UserModel userModel;
  BucketInfoController({required this.repository});
  var newEntry = true;
  var entries = [].obs;

  @override
  void onInit() {
    super.onInit();
    HomeController homeController = Get.find<HomeController>();
    userModel = homeController.args;
    // var x = repository.getBucketEntries(bucketModel.bucketId).listen((event) {
    //   entries.value = event;
    // });
    entries.bindStream(repository.getBucketEntries(bucketModel.bucketId));
  }

  @override
  void onReady() {
    super.onReady();
    // entries.listen((p0) {
    //   print("READY : ${p0}");
    // });
  }

  @override
  void onClose() {}
}
