import 'package:Match/model/ApiService.dart';
import 'package:Match/model/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PointController extends GetxController {
  final matchStatus = Status(status: 0).obs;
  var pointData = <Point>[].obs;

  final userData = User(
          code: '',
          name: '',
          type: '',
          status: 0,
          contest: '',
          peserta: List.empty())
      .obs;

  final box = GetStorage();
  String get isCode => box.read('code') ?? '';

  @override
  void onInit() {
    super.onInit();
    dataUser();
  }

  void dataUser() async {
    var user = await ApiService.login(isCode);
    userData(user);
  }

  void checkStatus() async {
    try {
      var data = await ApiService.status(isCode);
      matchStatus(data);
      if (matchStatus.value.status != 2) {
        Get.snackbar('Error', 'Pertandingan Sudah selesai atau Belum di mulai',
            colorText: Colors.white, backgroundColor: Colors.red[800]);
      } else {
        Get.toNamed('/point');
      }
    } catch (e) {
      Get.snackbar('Error', 'Code Invalid',
          colorText: Colors.white, backgroundColor: Colors.red[800]);
    }
  }

  void UpdateStatus(String stat) async {
    await ApiService.UpStatus(stat, isCode);
    Get.snackbar('Success', 'Pertandingan di update',
        colorText: Colors.white, backgroundColor: Colors.green[800]);
  }


}
