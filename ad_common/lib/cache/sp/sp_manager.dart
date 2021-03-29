import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';
import 'package:ad_common/common/extension/string_extension.dart';

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

  static String _realName(Object name) {
    if (!(name is String)) name = name.toString().enumRowValue;
    return _isDebug ? "${name}_debug" : '$name';
  }

  static dynamic get(Object name) {
    if (name is String && name.isNull) return null;
    return _sharedPreferences?.get(_realName(name));
  }

  static bool getBool(name, {bool defaultValue = false}) {
    if (name is String && name.isNull) return defaultValue;
    try {
      return _sharedPreferences?.getBool(_realName(name)) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  static int getInt(name, {int defaultValue = 0}) {
    if (name is String && name.isNull) return defaultValue;
    try {
      return _sharedPreferences?.getInt(_realName(name)) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  static double getDouble(name, {double defaultValue = 0.0}) {
    if (name is String && name.isNull) return defaultValue;
    try {
      return _sharedPreferences?.getDouble(_realName(name)) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  static String getString(name, {String defaultValue = ''}) {
    if (name is String && name.isNull) return defaultValue;
    try {
      return _sharedPreferences?.getString(_realName(name)) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  static List<String> getStringList(name) {
    if (name is String && name.isNull) return [];
    try {
      return _sharedPreferences?.getStringList(_realName(name));
    } catch (e) {
      return [];
    }
  }

  static void setBool(name, bool value) {
    if ((name is String && name.isNull) || value == null) return;
    _sharedPreferences?.setBool(_realName(name), value);
  }

  static void setInt(name, int value) {
    if ((name is String && name.isNull) || value == null) return;
    _sharedPreferences?.setInt(_realName(name), value);
  }

  static void setDouble(name, double value) {
    if ((name is String && name.isNull) || value == null) return;
    _sharedPreferences?.setDouble(_realName(name), value);
  }

  static void setString(name, String value) {
    if ((name is String && name.isNull) || value == null) return;
    _sharedPreferences?.setString(_realName(name), value);
  }

  static void setStringList(name, List<String> value) {
    if ((name is String && name.isNull) || value == null) return;
    _sharedPreferences?.setStringList(_realName(name), value);
  }

  static void remove(name) {
    if (name is String && name.isNull) return;
    _sharedPreferences?.remove(_realName(name));
  }
}
