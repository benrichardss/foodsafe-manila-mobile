import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static Map<String, dynamic>? currentUser;
  static Map<String, dynamic>? userReport;
  static late SharedPreferences _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    final storedUser = _prefs.getString('current_user');

    if (storedUser != null && storedUser.isNotEmpty) {
      try {
        currentUser = jsonDecode(storedUser) as Map<String, dynamic>;
      } catch (_) {
        currentUser = null;
      }
    }
  }

  static Future<void> saveCurrentUser(Map<String, dynamic> user) async {
    currentUser = user;
    await _prefs.setString('current_user', jsonEncode(user));
  }

  static Future<void> clear() async {
    currentUser = null;
    await _prefs.remove('current_user');
  }
}
