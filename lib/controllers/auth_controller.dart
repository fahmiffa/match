import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Match/model/ApiService.dart';
import 'package:get_storage/get_storage.dart';

import '../model/user.dart';

class AuthController extends GetxController {

  GetStorage box = GetStorage();

  bool get isWasit => box.read('wasit') ?? false;

  final userData = User(
          code: '',
          name: '',
          type: '',
          status: 0,
          contest: '',
          peserta: List.empty())
      .obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> login(String code) async {
    try {
      var user = await ApiService.login(code);
      userData(user);
      box.write('code', userData.value.code);
      if (userData.value.name == 'Wasit') {
        box.write('wasit', true);
        Get.offAllNamed('/main');
      } else {
        box.write('wasit', false);
        Get.offAllNamed('/home');
      }
      box.write('isLoggedIn', true);
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Code Invalid',
          colorText: Colors.white, backgroundColor: Colors.red[800]);
    }
  }

  void logout() {
    box.erase();
    Get.offNamed('/login');
  }
}
