import 'dart:convert';
import 'package:get_storage/get_storage.dart';

import '../model/ApiService.dart';
import '../model/user.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SockController extends GetxController {
  final channel = WebSocketChannel.connect(Uri.parse(ApiService.socketUrl));

  final receivedData = WebSocketData(type: 0, data: '').obs;

  RxBool isBroad = false.obs;
  RxString iscon = ''.obs;
  RxString timer = '00:00'.obs;
  RxBool isOpen = false.obs;
  RxInt isVal = 0.obs;

  final box = GetStorage();
  String get isCode => box.read('code') ?? '';
  int get isId => box.read('id') ?? 0;

  @override
  void onInit() {
    super.onInit();
    Broad();
  }

  void Broad() {
    print(timer.value);
    channel.stream.listen((message) {
      if (message is List<int>) {
        String jsonString = utf8.decode(message);
        Map<String, dynamic> da = jsonDecode(jsonString);

        if (da['type'] == 0 && da['req'] == isId) {
          timer.value = da['data'];
        }    
        if (da['type'] == 1) {
          isOpen.value = da['open'];
          if (da['data'] == 'drop') {
            isVal.value = 1;
          }
          if (da['data'] == 'coach') {
            isVal.value = 2;
          }
          if (da['data'] == 'teguran') {
            isVal.value = 3;
          }
          if (da['data'] == 'warning') {
            isVal.value = 4;
          }     
        }
      } else {
        var res = jsonDecode(message);
        Map<String, dynamic> jsonMap = json.decode(res);
        int type = jsonMap['type'];
        String data = jsonMap['data'];
        if (type == 0) {
          timer.value = data;
        }
      }

      isBroad.value = true;
      iscon.value = 'Connected';
    }, onDone: () {
      isBroad.value = true;
      iscon.value = 'Connected';
    }, onError: (e) {
      isBroad.value = false;
      iscon.value = 'Connecting';
      print('Error : $e');
    });
  }

  @override
  void onClose() {
    channel.sink.close();
    super.onClose();
  }
}
