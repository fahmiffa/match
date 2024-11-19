import 'package:Match/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/ApiService.dart';
import 'package:get_storage/get_storage.dart';
import '../model/user.dart';

class AuthController extends GetxController {
  RxBool isCore = false.obs;
  RxString uuid = ''.obs;
  RxBool isDev = true.obs;

  final box = GetStorage();
  String get isCode => box.read('code') ?? '';
  bool get isLogin => box.read('isLogin') ?? false;
  bool Ganda = false;

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
    status();
  }

  void checkLoginStatus() async {
    var stts = await getStatus();
    var device = await getDevices();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (stts) {
        Inject(device['id']);
        isCore.value = true;
      } else {
        box.erase();
        uuid.value = device['id'];
      }
    });
  }

  void Inject(String code) async {
    try {
      var user = await getData();
      userData(user);
      box.write('code', code);
      box.write('type', userData.value.type);
      box.write('id', userData.value.id);
      box.write('jur', userData.value.jurus);
      box.write('name', userData.value.name);

      List<String> gan = <String>['Ganda', 'Solo'];
      Ganda = gan.contains(userData.value.type);

      if (userData.value.name == 'dewan') {
        box.write('status', 'dewan');
        Get.offAllNamed('/home');
      } else if (userData.value.name == 'timer') {
        box.write('status', 'timer');
        Get.offAllNamed('/home');
      } else {
        box.write('status', 'juri');
        if (userData.value.type == 'Tanding') {
          Get.offAllNamed('/point');
        } else {
          if (Ganda) {
            Get.toNamed('/arts');
          } else {
            Get.toNamed('/art');
          }
        }
      }
      box.write('isLogin', true);
    } catch (e) {
      box.erase();
    }
  }

  void status() async {
    uuid.value = await getUdid();
    try {
      var user = await ApiService.sync();
      isDev.value = user;
      print(isDev);
    } catch (e) {
      print(e);
    }
  }

  void logout() {
    box.erase();
    Get.offAllNamed('/');
  }
}
