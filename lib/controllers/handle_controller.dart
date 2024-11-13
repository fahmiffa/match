import 'package:flutter/material.dart';

import '../model/ApiService.dart';
import '../model/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HandleController extends GetxController {
  final matchStatus = Status(status: 0, move: 0, ver: 0).obs;

  final box = GetStorage();
  String get isCode => box.read('code') ?? '';
  bool get isLogin => box.read('isLogin') ?? false;

  @override
  void onInit() {
    super.onInit();
  }

  LoadStatus() async {
    try {
      var data = await ApiService.status(isCode);
      matchStatus(data);
      return matchStatus.value.status == 2 ? true : false;
    } catch (e) {
      Get.snackbar('Error', '${e}',
          colorText: Colors.white, backgroundColor: Colors.red[800]);
    }
  }

  LoadTimer() async {
    try {
      var data = await ApiService.status(isCode);
      matchStatus(data);
      return matchStatus.value.move == 1 ? true : false;
    } catch (e) {
      Get.snackbar('Error', '${e}',
          colorText: Colors.white, backgroundColor: Colors.red[800]);
    }
  }
}
