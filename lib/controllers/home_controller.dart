import 'dart:convert';
import 'package:Match/helper.dart';
import '../model/ApiService.dart';
import '../model/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeController extends GetxController {
  final channel = WebSocketChannel.connect(Uri.parse(ApiService.socketUrl));

  final matchStatus = Status(status: 0, move: 0, ver: 0).obs;
  var pointData = <Point>[].obs;
  var tipe = <String>[].obs;

  bool isBroad = false;
  RxBool isMatch = false.obs;
  bool Ganda = false;
  var tabCount = 0.obs;

  RxString label = ''.obs;

  final box = GetStorage();
  String get isCode => box.read('code') ?? '';
  String get istype => box.read('type') ?? '';
  String get isStatus => box.read('status') ?? '';

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
    var user = await ApiService.login(isCode);
    userData(user);
    isMatch.value = istype == 'Tanding' ? true : false;
    List<String> gan = <String>['Ganda', 'Solo'];
    Ganda = gan.contains(istype);
    tabCount.value = istype == 'Tanding' ? 5 : 2;
    var data = await ApiService.status(isCode);
    matchStatus(data);
  }

  void checkStatus() async {
    var stts = await getStatus();
    if (stts) {
      try {
        if (isStatus == 'dewan') {
          Get.offAllNamed('/main');
        } else {
          var data = await ApiService.status(isCode);
          matchStatus(data);
          if (matchStatus.value.status == 0) {
            Get.snackbar('Error', 'Dewan belum memulai pertandingan',
                colorText: Colors.white, backgroundColor: Colors.red[800]);
          } else {
            if (isStatus == 'timer') {
              Get.offAllNamed('/timer');
            } else {
              if (matchStatus.value.move == 0) {
                Get.snackbar('Error', 'Timer belum memulai pertandingan',
                    colorText: Colors.white, backgroundColor: Colors.red[800]);
              } else {
                if (istype == 'Tanding') {
                  Get.offAllNamed('/point');
                } else {
                  if (Ganda) {
                    Get.toNamed('/arts');
                  } else {
                    Get.toNamed('/art');
                  }
                }
              }
            }
          }
        }
      } catch (e) {
        Get.snackbar('Error', 'Code Invalid ${e}',
            colorText: Colors.white, backgroundColor: Colors.red[800]);
      }
    } else {
      box.erase();
      Get.offAllNamed('/');
    }
  }

  void UpdateStatus(String stat) async {
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
