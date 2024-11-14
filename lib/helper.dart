import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import '../model/ApiService.dart';
import 'package:flutter_udid/flutter_udid.dart';

getDevices() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  var udid = await getUdid();

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    var res = {'id': udid, 'brand': androidInfo.brand};

    return res;
  } else if (Platform.isWindows) {
    WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
    var res = {
      'id': udid,
      'brand': windowsInfo.computerName
    };
    return res;
  } else {
    var res = {'id': null, 'brand': null};
    return res;
  }
}

getStatus() async {
  try {
    var device = await getDevices();
    await ApiService.login(device['id']);
    return true;
  } catch (e) {
    return false;
  }
}

getUdid() async {
  String udid;
  try {
    udid = await FlutterUdid.udid;
  } on PlatformException {
    udid = 'Failed to get UDID.';
  }
  return udid;
}
