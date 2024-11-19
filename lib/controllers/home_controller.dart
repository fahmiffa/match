import 'dart:convert';
import '../helper.dart';
import '../model/ApiService.dart';
import '../model/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'handle_controller.dart';

class HomeController extends GetxController {
  final channel = WebSocketChannel.connect(Uri.parse(ApiService.socketUrl));
  final HandleController dataController = Get.put(HandleController());

  final matchStatus = Status(status: 0, move: 0, ver: 0).obs;
  var pointData = <Point>[].obs;
  var tipe = <String>[].obs;

  bool isBroad = false;
  RxBool isMatch = false.obs;
  bool Ganda = false;
  var tabCount = 0.obs;

  RxString label = ''.obs;

  final userData = User(
          id: 0,
          code: '',
          name: '',
          partai: '',
          babak: '',
          kelas: '',
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
    dataMain();
  }

  void dataMain() async {
    String isCode = await getUdid();
    var user = await getData();
    userData(user);
    isMatch.value = userData.value.type == 'Tanding' ? true : false;
    List<String> gan = <String>['Ganda', 'Solo'];
    Ganda = gan.contains(userData.value.type);
    tabCount.value = userData.value.type == 'Tanding' ? 5 : 2;
    var data = await ApiService.status(isCode);
    matchStatus(data);
  }

  void checkStatus() async {
    var stts = await getStatus();
    if (stts) {
      try {
        if (userData.value.name == 'dewan') {
          Get.offAllNamed('/main');
        } else {
          var status = await dataController.LoadStatus();
          if (!status) {
            throw Exception('Pertandingan belum di mulai');
          }
          Get.offAllNamed('/timer');
        }
      } catch (e) {
        Get.snackbar('Error', '${e}',
            colorText: Colors.white, backgroundColor: Colors.red[800]);
      }
    } else {
      Get.offAllNamed('/');
    }
  }

  void UpdateStatus(String stat) async {
    String isCode = await getUdid();
    try {
      var data = await ApiService.upStatus(stat, isCode);
      matchStatus(data);
      Get.snackbar('Success', 'Pertandingan di update',
          colorText: Colors.white, backgroundColor: Colors.green[800]);
    } catch (e) {
      print(e);
    }
  }

  void UpdateDrop(String stat, String val, String type) async {
    String isCode = await getUdid();
    try {
      await ApiService.upDrop(stat, val, isCode, type);
      Get.snackbar('Success', 'Pertandingan di update',
          colorText: Colors.white, backgroundColor: Colors.green[800]);
    } catch (e) {
      Get.snackbar('Error', '${e}',
          colorText: Colors.white, backgroundColor: Colors.red);
    }
  }

  void UpdateVer(String stat) async {
    String isCode = await getUdid();
    try {
      if (tipe.contains(stat)) {
        tipe.remove(stat);
        await ApiService.upVerif('close', isCode);
        Map<String, dynamic> jsonMap = {
          "type": 1,
          "data": stat,
          "open": false,
          "Iscode": isCode
        };
        String jsonString = jsonEncode(jsonMap);
        channel.sink.add(jsonString);
      } else {
        await ApiService.upVerif(stat, isCode);
        tipe.add(stat);

        Map<String, dynamic> jsonMap = {
          "type": 1,
          "data": stat,
          "open": true,
          "Iscode": isCode
        };
        String jsonString = jsonEncode(jsonMap);
        channel.sink.add(jsonString);
      }
      Get.snackbar('Success', 'Pertandingan di update',
          colorText: Colors.white, backgroundColor: Colors.green[800]);
    } catch (e) {
      print(e);
    }
  }
}
