import 'dart:convert';

import 'package:Match/model/ApiService.dart';
import 'package:Match/model/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:developer';

class PointsController extends GetxController {
  var pointData = <Point>[].obs;
  var peserta = <Peserta>[].obs;

  final box = GetStorage();
  String get isCode => box.read('code') ?? '';

  @override
  void onInit() {
    super.onInit();
    dataPoint();
  }

  void dataPoint() async {
    var da = await ApiService.cPoint(isCode);
    final List<dynamic> data = da['peserta'];
    peserta.assignAll(data.map((json) => Peserta.fromJson(json)).toList());

    final List<dynamic> dap = da['point'];
    pointData.assignAll(dap.map((json) => Point.fromJson(json)).toList());
  }

  void addValue(String val, int id) async {
    try {
      var data = await ApiService.UpValue(val, isCode, id);
      Get.snackbar('Success', 'Input Success',
          colorText: Colors.white, backgroundColor: Colors.green[800]);
    } catch (e) {
      Get.snackbar('Error', 'Match Stopped',
          colorText: Colors.white, backgroundColor: Colors.red[800]);
    }
  }
}
