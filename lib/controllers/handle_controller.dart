import 'package:Match/helper.dart';
import 'package:flutter/material.dart';
import '../model/ApiService.dart';
import '../model/user.dart';
import 'package:get/get.dart';

class HandleController extends GetxController {
  final matchStatus = Status(status: 0, move: 0, ver: 0).obs;

  @override
  void onInit() {
    super.onInit();
  }

  LoadStatus() async {
    try {
      String isCode = await getUdid();
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
      String isCode = await getUdid();
      var data = await ApiService.status(isCode);
      matchStatus(data);
      return matchStatus.value.move == 1 ? true : false;
    } catch (e) {
      Get.snackbar('Error', '${e}',
          colorText: Colors.white, backgroundColor: Colors.red[800]);
    }
  }
}
