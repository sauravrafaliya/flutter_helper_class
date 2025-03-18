
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class PrefSettings {
  static final PrefSettings _instance = PrefSettings
      ._internal();

  factory PrefSettings() => _instance;


  PrefSettings._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const String keyUserName = 'keyUserName';
  static const String keyPassword = 'keyPassword';
  static const String keyCurrentUserId = 'keyCurrentUserId';
  static const String keyUserModel = 'keyUserModel';

  String get currentUserName => _prefs.getString(keyUserName) ?? '';
  set currentUserName(String value) => _prefs.setString(keyUserName, value);

  String get currentUserPassword => _prefs.getString(keyPassword) ?? '';
  set currentUserPassword(String value) => _prefs.setString(keyPassword, value);

  int get currentUserId => _prefs.getInt(keyCurrentUserId) ?? 0;
  set currentUserId(int value) => _prefs.setInt(keyCurrentUserId, value);
}
