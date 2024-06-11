import 'dart:async';

import 'package:Match/model/ApiService.dart';
import 'package:Match/model/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RealtimeController extends GetxController {
  final matchStatus = Status(status: 0).obs;

  final box = GetStorage();
  String get isCode => box.read('code') ?? '';

  @override
  void onInit() {
    super.onInit();
    Timer.periodic(Duration(seconds: 3), (timer) {
      LoadStatus();
    });
  }


  void LoadStatus() async {
    var data = await ApiService.status(isCode);
    matchStatus(data);
  }

}
