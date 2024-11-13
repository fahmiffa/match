import '../model/ApiService.dart';
import '../model/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RealtimeController extends GetxController {
  final matchStatus = Status(status: 0, move: 0, ver: 0).obs;

  final box = GetStorage();
  String get isCode => box.read('code') ?? '';
  bool get isLogin => box.read('isLogin') ?? false;

  @override
  void onInit() {
    super.onInit();
    LoadStatus();
    //   Timer.periodic(Duration(seconds: 3), (timer) {
    //     LoadStatus();   
    // });
  }

  void LoadStatus() async {
    try {
      var data = await ApiService.status(isCode);
      matchStatus(data);
    } catch (e) {
      print(e);
    }
  }
}
