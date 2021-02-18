import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

/// 偏好设置存储管理类
class SpManager {
  static Lock _lock = Lock();
  static SharedPreferences _sharedPreferences;

  /// 不同环境存储不同字段
  static bool _isDebug = false;

  static Future init({isDebug = false}) async {
    _isDebug = isDebug;
    if (_sharedPreferences == null) {
      await _lock.synchronized(() async {
        if (_sharedPreferences == null) {
          _sharedPreferences = await SharedPreferences.getInstance();
        }
      });
    }
    return true;
  }

  static String _realName(name) => _isDebug ? "${name}_debug" : '$name';

  static dynamic get(String name) {
    return _sharedPreferences?.get(_realName(name));
  }

  static bool getBool(String name, {bool defaultValue = false}) {
    return _sharedPreferences?.getBool(_realName(name)) ?? defaultValue;
  }

  static int getInt(String name, {int defaultValue = 0}) {
    return _sharedPreferences?.getInt(_realName(name)) ?? defaultValue;
  }

  static double getDouble(String name, {double defaultValue = 0.0}) {
    return _sharedPreferences?.getDouble(_realName(name)) ?? defaultValue;
  }

  static String getString(String name, {String defaultValue = ''}) {
    return _sharedPreferences?.getString(_realName(name)) ?? defaultValue;
  }

  static List<String> getStringList(String name) {
    return _sharedPreferences?.getStringList(_realName(name));
  }

  static void setBool(String name, bool value) {
    _sharedPreferences?.setBool(_realName(name), value);
  }

  static void setInt(String name, int value) {
    _sharedPreferences?.setInt(_realName(name), value);
  }

  static void setDouble(String name, double value) {
    _sharedPreferences?.setDouble(_realName(name), value);
  }

  static void setString(String name, String value) {
    _sharedPreferences?.setString(_realName(name), value);
  }

  static void setStringList(String name, List<String> value) {
    _sharedPreferences?.setStringList(_realName(name), value);
  }

  static void remove(String name) {
    _sharedPreferences?.remove(_realName(name));
  }
}
