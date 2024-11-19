import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../helper.dart';
import '../model/ApiService.dart';
import '../model/user.dart';
import 'package:get/get.dart';
import 'handle_controller.dart';

class PointController extends GetxController {
  final HandleController dataController = Get.put(HandleController());
  final channel = WebSocketChannel.connect(Uri.parse(ApiService.socketUrl));
  var pointData = <Point>[].obs;
  var peserta = <Peserta>[].obs;
  var side = List.empty();
  RxList blue = [0, 0].obs;
  RxList red = [0, 0].obs;
  RxInt hit = 0.obs;
  RxInt kick = 0.obs;

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
    dataPoint();
  }

  void dataPoint() async {
    String isCode = await getUdid();
    var da = await ApiService.cPoint(isCode);
    final List<dynamic> data = da['peserta'];
    peserta.assignAll(data.map((json) => Peserta.fromJson(json)).toList());
    final List<dynamic> dap = da['point'];
    pointData.assignAll(dap.map((json) => Point.fromJson(json)).toList());
  }

  parseName(String name, int tipe, String par) {
    String cor = tipe == 1 ? 'blue' : 'red';
    String nam = name.replaceAll('Juri ', 'j');
    return '${nam}-${cor}-${par.toLowerCase()}';
  }

  void addValue(String val, int id, String type, tipe) async {
    var status = await dataController.LoadStatus();
    var timer = await dataController.LoadTimer();
    String isCode = await getUdid();
    var user = await getData();
    userData(user);
    String isName = userData.value.name;

    try {
      if (!status) {
        throw Exception('Pertandingan belum di mulai');
      }

      if (!timer) {
        throw Exception('TImer belum berjalan');
      }

      await ApiService.upValue(val, isCode, id, type);
      String juri = parseName(isName, int.parse(tipe), type);

      Map<String, dynamic> jsonMap = {
        "type": 3,
        "data": juri,
        "Iscode": isCode
      };
      String jsonString = jsonEncode(jsonMap);
      channel.sink.add(jsonString);
      if (type == 'Hit') {
        int val = 1;
        if (int.parse(tipe) == 1) {
          blue[0] += val;
        }
        if (int.parse(tipe) == 2) {
          red[0] += val;
        }
      }

      if (type == 'Kick') {
        int val = 1;
        if (int.parse(tipe) == 1) {
          blue[1] += val;
        }
        if (int.parse(tipe) == 2) {
          red[1] += val;
        }
      }
    } catch (e) {
      Get.snackbar('Error', '${e}',
          colorText: Colors.white, backgroundColor: Colors.red[800]);
    }
  }

  void addValueVer(String val, int id, String type, tipe) async {
    String isCode = await getUdid();
    var user = await getData();
    userData(user);
    String isName = userData.value.name;
    try {
      await ApiService.upValue(val, isCode, id, type);
      String juri = parseName(isName, int.parse(tipe), type);

      Map<String, dynamic> jsonMap = {
        "type": 3,
        "data": juri,
        "Iscode": isCode
      };
      String jsonString = jsonEncode(jsonMap);
      channel.sink.add(jsonString);

      if (type == 'Hit') {
        int val = 1;
        if (int.parse(tipe) == 1) {
          blue[0] += val;
        }
        if (int.parse(tipe) == 2) {
          red[0] += val;
        }
      }

      if (type == 'Kick') {
        int val = 1;
        if (int.parse(tipe) == 1) {
          blue[1] += val;
        }
        if (int.parse(tipe) == 2) {
          red[1] += val;
        }
      }
    } catch (e) {
      Get.snackbar('Error', '${e}',
          colorText: Colors.white, backgroundColor: Colors.red[800]);
    }
  }
}
