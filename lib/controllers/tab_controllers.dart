import 'package:Match/controllers/handle_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helper.dart';
import '../model/ApiService.dart';
import '../model/user.dart';

class TabControllers extends GetxController
    with GetSingleTickerProviderStateMixin {
  final HandleController dataController = Get.put(HandleController());
  late TabController tabController;

  RxBool button = true.obs;
  RxBool buttonPower = true.obs;

  bool attack = true;
  bool firmness = true;
  bool foul = true;
  RxDouble score = 0.00.obs;

  var append = <dynamic, dynamic>{}.obs;

  final List<Tab> tabs = <Tab>[].obs;
  var dataVal = <int>[].obs;
  RxInt active = 0.obs;
  RxString modVal = ''.obs;
  RxMap points = <int, dynamic>{}.obs;
  var juri = [].obs;
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
    getPoint();
    // startUp();
    tabController =
        TabController(vsync: this, length: tabs.length, initialIndex: 0);
    super.onInit();
  }

  void getPoint() async {
    var user = await getData();
    userData(user);
    modVal.value = userData.value.point;

    if (userData.value.type == 'Ganda') {
      juri.value = [
        {'val': 'Penampilan melebihi waktu toleransi', 'index': 1},
        {'val': 'Keluar gelanggang', 'index': 2},
        {'val': 'Senjata jatuh tidak sesuai dengan sinopsis', 'index': 3},
        {'val': 'Senjata Jatuh di luar gelanggang', 'index': 4},
        {'val': 'Pakaian tidak sesuai persyaratan', 'index': 5},
        {'val': 'Menahan gerakan lebih dari 5 detik', 'index': 6}
      ];
    } else if (userData.value.type == 'Tunggal') {
      juri.value = [
        {'val': 'Penampilan melebihi batas waktu toleransi', 'index': 1},
        {'val': 'Keluar Gelanggang (10x10m)', 'index': 2},
        {'val': 'Pakain/Senjata tidak sempurna', 'index': 3},
        {'val': 'Senjata Jatuh', 'index': 4},
        {'val': 'Menahan Gerakan lebih dari 5 detik', 'index': 5},
        {
          'val': 'Berhenti dengan jarak lebih dari 1 meter dari posisi awal',
          'index': 6
        }
      ];
    } else if (userData.value.type == 'Solo') {
      juri.value = [
        {'val': 'Penampilan melebihi waktu toleransi', 'index': 1},
        {'val': 'Keluar gelanggang', 'index': 2},
        {'val': 'Senjata jatuh tidak sesuai dengan sinopsis', 'index': 3},
        {'val': 'Senjata Jatuh keluar gelanggang', 'index': 4},
      ];
    } else if (userData.value.type == 'Regu') {
      juri.value = [
        {'val': 'Penampilan melebihi waktu toleransi', 'index': 1},
        {'val': 'Keluar gelanggang (10×10m)', 'index': 2},
        {'val': 'Pakaian tidak sesuai persyaratan', 'index': 3},
        {'val': 'Menahan gerakan lebih dari 5 detik', 'index': 4}
      ];
    }
  }

  // void startUp() {
  //   for (int i = 0; i < int.parse(isJurus); i++) {
  //     tabs.add(Tab(
  //       child: Text(
  //         'Jurus ${i + 1}',
  //         overflow: TextOverflow.ellipsis,
  //       ),
  //     ));
  //   }
  // }

  void addArt(String val, String type) async {
    button.value = false;
    String isCode = await getUdid();
    var status = await dataController.LoadStatus();
    var timer = await dataController.LoadTimer();

    try {
      if (!status) {
        throw Exception('Pertandingan belum di mulai');
      }

      if (!timer) {
        throw Exception('TImer belum berjalan');
      }

      var data = await ApiService.cArt(isCode, val, type);
      modVal.value = data.toString();
      button.value = true;
    } catch (e) {
      Get.snackbar('Error', '${e}',
          colorText: Colors.white, backgroundColor: Colors.red[800]);
      button.value = true;
    }
  }

  void addGanda(String val, String type, int par) async {
    var status = await dataController.LoadStatus();
    var timer = await dataController.LoadTimer();
    String isCode = await getUdid();

    try {
      if (!status) {
        throw Exception('Pertandingan belum di mulai');
      }

      if (!timer) {
        throw Exception('TImer belum berjalan');
      }

      if (par == 0) {
        attack = false;
        append[par] = val;
      }
      if (par == 1) {
        firmness = false;
        append[par] = val;
      }
      if (par == 2) {
        foul = false;
        append[par] = val;
      }

      score.value += double.parse(val);
      var data = await ApiService.cArt(isCode, val, type);
      modVal.value = data.toString();
    } catch (e) {
      Get.snackbar('Error', '${e}',
          colorText: Colors.white, backgroundColor: Colors.red[800]);
    }
  }

  void addPower(String val, String type, int index) async {
    var status = await dataController.LoadStatus();
    String isCode = await getUdid();
    try {
      if (!status) {
        throw Exception('Pertandingan belum di mulai');
      }

      await ApiService.cArt(isCode, val, type);
      active.value = index;
      buttonPower.value = false;
    } catch (e) {
      Get.snackbar('Error', '${e}',
          colorText: Colors.white, backgroundColor: Colors.red[800]);
    }
  }

  void addPoint(String val, String type, int index) async {
    var status = await dataController.LoadStatus();
    var timer = await dataController.LoadTimer();
    String isCode = await getUdid();
    try {
      if (!status) {
        throw Exception('Pertandingan belum di mulai');
      }

      if (!timer) {
        throw Exception('TImer belum berjalan');
      }

      await ApiService.cArt(isCode, val, type);
      if (points.containsKey(index)) {
        points[index] = double.parse(val);
      } else {
        points[index] = double.parse(val);
      }
    } catch (e) {
      Get.snackbar('Error', '${e}',
          colorText: Colors.white, backgroundColor: Colors.red[800]);
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
