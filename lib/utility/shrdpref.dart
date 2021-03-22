import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences _preferences;
  static const _keyUsername = 'username';
  static const _keyfatherName = 'fathername';
  static const _keyPhonNum = 'phone';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUsername(String username) async =>
      await _preferences.setString(_keyUsername, username);

  static String getUsername() => _preferences.getString(_keyUsername);

  static Future setFatherName(String fatherName) async =>
      await _preferences.setString(_keyfatherName, fatherName);

  static String getFatherName() => _preferences.getString(_keyfatherName);

  static Future setPhone(String phone) async =>
      await _preferences.setString(_keyPhonNum, phone);

  static String getPhone() => _preferences.getString(_keyPhonNum);
}
