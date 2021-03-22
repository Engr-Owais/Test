import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

const IMAGE_KEY = 'IMAGE_KEY';

class SharedPrefs {
  static SharedPreferences _preferences;
  static const _keyUsername = 'username';
  static const _keyfatherName = 'fathername';
  static const _keyPhonNum = 'phone';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();
  static Future<bool> saveImageToPrefs(String value) async {
    return await _preferences.setString(IMAGE_KEY, value);
  }

  static Future<bool> emptyPrefs() async {
    return await _preferences.clear();
  }

  static Future<String> loadImageFromPrefs() async {
    return _preferences.getString(IMAGE_KEY);
  }

  // encodes bytes list as string
  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  // decode bytes from a string
  static imageFrom64BaseString(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }

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
