import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyLoggedIn = 'loggedIn';

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_keyLoggedIn, value);
  }

}
