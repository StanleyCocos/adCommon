import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';


/// 偏好设置存储管理类
class SpManager {
  static SpManager _singleton;
  static Lock _lock = Lock();
  static SharedPreferences _sharedPreferences;

  static Future<SpManager> getInstance() async {
    if (_singleton == null) {
      await _lock.synchronized(() async {
        if (_singleton == null) {
          // keep local instance till it is fully initialized.
          // 保持本地实例直到完全初始化。
          var singleton = SpManager._();
          await singleton._init();
          _singleton = singleton;
        }
      });
    }
    return _singleton;
  }

  SpManager._();

  Future _init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static dynamic get(String name) => _sharedPreferences?.get(name);

  static bool getBool(String name, {bool defaultValue = false}) =>
      _sharedPreferences?.getBool(name) ?? defaultValue;

  static int getInt(String name, {int defaultValue = 0}) =>
      _sharedPreferences?.getInt(name) ?? defaultValue;

  static double getDouble(String name, {double defaultValue = 0.0}) =>
      _sharedPreferences?.getDouble(name) ?? defaultValue;

  static String getString(String name, {String defaultValue = ""}) =>
      _sharedPreferences?.getString(name) ?? defaultValue;

  static List<String> getStringList(String name) =>
      _sharedPreferences?.getStringList(name);

  static void setBool(String name, bool value) =>
      _sharedPreferences?.setBool(name, value);

  static void setInt(String name, int value) =>
      _sharedPreferences?.setInt(name, value);

  static void setDouble(String name, double value) =>
      _sharedPreferences?.setDouble(name, value);

  static void setString(String name, String value) =>
      _sharedPreferences?.setString(name, value);

  static void setStringList(String name, List<String> value) =>
      _sharedPreferences?.setStringList(name, value);

  static void remove(String name) {
    _sharedPreferences?.remove(name);
  }
}
