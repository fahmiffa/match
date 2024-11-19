import '../model/ApiService.dart';
import '../model/user.dart';
import 'package:get/get.dart';
import '../helper.dart';

class RealtimeController extends GetxController {
  final matchStatus = Status(status: 0, move: 0, ver: 0).obs;


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
      String isCode = await getUdid();
      var data = await ApiService.status(isCode);
      matchStatus(data);
    } catch (e) {
      print(e);
    }
  }
}
