import 'package:Match/helper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/ApiService.dart';
import 'package:get_storage/get_storage.dart';
import '../model/user.dart';
import 'dart:async';

class AuthController extends GetxController {
  var deviceid = ''.obs;
  var deviceBrand = ''.obs;
  var qey = ''.obs;
  RxBool Bsync = false.obs;

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Future<void> getDeviceSerial() async {
    try {
      var device = await getDevices();
      await ApiService.devices(device['id'], device['brand']);
      Get.snackbar('Succes', 'Device Snysc',
          colorText: Colors.white, backgroundColor: Colors.green[800]);
    } catch (e) {}
  }

  RxBool isWasit = false.obs;
  RxString uuid = ''.obs;

  final box = GetStorage();
  String get isCode => box.read('code') ?? '';
  bool get isLogin => box.read('isLogin') ?? false;
  bool get isCore => box.read('core') ?? false;
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
    sync();
  }

  void sync() async {
    try {
      var da = await ApiService.sync();
      Bsync.value = da;
    } catch (e) {}
  }

  void checkLoginStatus() async {
    var stts = await getStatus();
    var device = await getDevices();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (stts) {
        Inject(device['id']);
      } else {
        print('gas');
        box.erase();
        uuid.value = device['id'];
      }
    });
  }

  void Inject(String code) async {
    try {
      var user = await ApiService.login(code);
      userData(user);
      box.write('core', true);
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

  void login(String code) async {
    try {
      var user = await ApiService.login(code);
      userData(user);
      box.write('code', userData.value.code);
      box.write('type', userData.value.type);
      box.write('id', userData.value.id);
      box.write('jur', userData.value.jurus);
      box.write('name', userData.value.name);

      if (userData.value.name == 'dewan') {
        box.write('status', 'dewan');
      } else if (userData.value.name == 'timer') {
        box.write('status', 'timer');
      } else {
        box.write('status', 'juri');
      }
      Get.offAllNamed('/home');
      box.write('isLogin', true);
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Code Invalid',
          colorText: Colors.white, backgroundColor: Colors.red[800]);
    }
  }

  void logout() {
    box.erase();
    Get.offAllNamed('/');
  }
}
