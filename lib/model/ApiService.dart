import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class ApiService {
  
  static late String perangkat;
  final box = GetStorage();

  static const String socketUrl = 'wss://socket.qrana.biz.id';
  static const String baseUrl = 'https://dev.qcode.my.id/api';

  static Future<User?> login(String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth'),
      body: {'code': code},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return User.fromJson(jsonData);
    } else {
      throw Exception('Failed to login');
    }
  }

  static Future<Status?> status(String code) async {

    final response = await http.post(
      Uri.parse('$baseUrl/auth'),
      body: {'code': code},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Status.fromJson(jsonData);
    } else {
      throw Exception('Failed to statuse');
    }
  }

  static cArt(String code, String val, String type) async {
    
    final response = await http.post(
      Uri.parse('$baseUrl/art'),
      body: {'code': code, 'val': val, 'type': type},
    );

    print(response.body);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to point');
    }
  }

  static upDrop(String stat, String val, String code, String type) async {
    final response = await http.post(
      Uri.parse('$baseUrl/drop'),
      body: {'code': code, 'val': stat, 'side': val, 'type': type},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to status');
    }
  }

  static upStatus(String stat, String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/status'),
      body: {'code': code, 'status': stat},
    );

    print(response.body);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Status.fromJson(jsonData);
    } else {
      throw Exception('Failed to status');
    }
  }

  static upVerif(String stat, String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verif'),
      body: {'code': code, 'status': stat},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData;
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
      return jsonData;
    } else {
      throw Exception('Failed to point');
    }
  }

  static upValue(String id, String code, int per, String type) async {
    DateTime now = DateTime.now();
    String tim = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    final response = await http.post(
      Uri.parse('$baseUrl/value'),
      body: {
        'code': code,
        'point': id,
        'peserta': per.toString(),
        'type': type,
        'time': tim
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to value');
    }
  }

  static upTimer(String status, String code, String timer) async {
    final response = await http.post(
      Uri.parse('$baseUrl/timer'),
      body: {'code': code, 'status': status, 'time': timer},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Waktu.fromJson(json)).toList();
    } else {
      throw Exception('Failed to status');
    }
  }

  static sync() async {
    final response = await http.get(Uri.parse('$baseUrl/sync'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to status');
    }
  }

  static devices(String code, String brand) async {
    final response = await http.post(
      Uri.parse('$baseUrl/devices'),
      body: {'build': code, 'brand': brand},
    );

    print(response.body);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to status');
    }
  }
}
