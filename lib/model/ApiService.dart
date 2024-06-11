import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Match/model/user.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_storage/get_storage.dart';

class ApiService {
  final box = GetStorage();

  static const String baseUrl = 'https://match.qcode.my.id/api';

  static Future<User?> login(String code) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    final response = await http.post(
      Uri.parse('$baseUrl/auth'),
      body: {'code': code, 'device': androidInfo.brand},
    );


    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return User.fromJson(jsonData);
    } else {
      print(response.statusCode );
      throw Exception('Failed to login');
    }
  }

  static Future<Status?> status(String code) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    final response = await http.post(
      Uri.parse('$baseUrl/auth'),
      body: {'code': code, 'device': androidInfo.brand},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Status.fromJson(jsonData);
    }
  }

  static UpStatus(String stat, String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/status'),
      body: {'code': code, 'status': stat},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
    } else {
      throw Exception('Failed to status');
    }
  }

  static cPoint(String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/point'),
      body: {'code': code},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      // return Value.fromJson(jsonData);
      return jsonData;
    } else {
      throw Exception('Failed to point');
    }
  }

  static UpValue(String id, String code, int per) async {
    final response = await http.post(
      Uri.parse('$baseUrl/value'),
      body: {'code': code, 'point': id, 'peserta': per.toString()},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
    } else {
      throw Exception('Failed to status');
    }
  }
}
