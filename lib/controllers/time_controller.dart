import 'dart:async';
import 'dart:convert';
import '../helper.dart';
import '../model/user.dart';
import 'package:get/get.dart';
import '../model/ApiService.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'handle_controller.dart';

class TimeController extends GetxController {
  final channel = WebSocketChannel.connect(Uri.parse(ApiService.socketUrl));
  final HandleController dataController = Get.put(HandleController());

  RxInt seconds = 0.obs;
  RxInt minutes = 0.obs;
  RxInt hours = 0.obs;
  String time = '';
  RxBool isRunning = false.obs;
  Timer? _timer;
  String run = '';

  var times = <Waktu>[].obs;

  final userData = User(
          id: 0,
          code: '',
          name: '',
          partai: '',
          kelas: '',
          babak: '',
          type: '',
          point: '',
          status: 0,
          jurus: 0,
          contest: '',
          peserta: List.empty(),
          side: List.empty(),
          kontingen: List.empty())
      .obs;

  @override
  void onInit() {
    super.onInit();
  }

  void startTimer() async {
    var user = await getData();
    userData(user);
    int isId = userData.value.id;
    dataController.LoadStatus();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      seconds.value++;
      if (seconds.value >= 60) {
        seconds.value = 0;
        minutes.value++;
        if (minutes.value >= 60) {
          minutes.value = 0;
          hours.value++;
        }
      }

      run =
          '${minutes.value.toString().padLeft(2, '0')}:${seconds.value.toString().padLeft(2, '0')}';

      Map<String, dynamic> jsonMap = {"type": 0, "data": "${run}", "req": isId};
      String jsonString = jsonEncode(jsonMap);
      channel.sink.add(jsonString);
    });
    isRunning.value = true;

    time =
        '${minutes.value.toString().padLeft(2, '0')}:${seconds.value.toString().padLeft(2, '0')}';

    UpdateTime('start', time);
  }

  void resetTimer() {
    _timer?.cancel();
    seconds.value = 0;
    minutes.value = 0;
    hours.value = 0;
    isRunning.value = false;
  }

  void stopTimer() {
    _timer?.cancel();
    isRunning.value = false;
    time =
        '${minutes.value.toString().padLeft(2, '0')}:${seconds.value.toString().padLeft(2, '0')}';
    UpdateTime('stop', time);
    dataController.LoadStatus();
  }

  void UpdateTime(String stat, String timer) async {
    String isCode = await getUdid();
    var tim = await ApiService.upTimer(stat, isCode, timer);
    times.assignAll(tim);
  }

  @override
  void onClose() {
    _timer?.cancel();
    channel.sink.close();
    super.onClose();
  }
}
