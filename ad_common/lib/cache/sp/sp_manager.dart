import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

/// 偏好设置存储管理类
class SpManager {
  static SpManager _singleton;
  static Lock _lock = Lock();
  static SharedPreferences _sharedPreferences;

  //不同环境存储不同字段
  static bool isDebug = false;

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

  String _realName(name) => name += isDebug ? '_debug' : '';

  dynamic get(String name) {
    return _sharedPreferences?.get(_realName(name));
  }

  bool getBool(String name, {bool defaultValue = false}) {
    return _sharedPreferences?.getBool(_realName(name)) ?? defaultValue;
  }

  int getInt(String name, {int defaultValue = 0}) {
    return _sharedPreferences?.getInt(_realName(name)) ?? defaultValue;
  }

  double getDouble(String name, {double defaultValue = 0.0}) {
    return _sharedPreferences?.getDouble(_realName(name)) ?? defaultValue;
  }

  String getString(String name, {String defaultValue = ''}) {
    return _sharedPreferences?.getString(_realName(name)) ?? defaultValue;
  }

  List<String> getStringList(String name) {
    return _sharedPreferences?.getStringList(_realName(name));
  }

  void setBool(String name, bool value) {
    _sharedPreferences?.setBool(_realName(name), value);
  }

  void setInt(String name, int value) {
    _sharedPreferences?.setInt(_realName(name), value);
  }

  void setDouble(String name, double value) {
    _sharedPreferences?.setDouble(_realName(name), value);
  }

  void setString(String name, String value) {
    _sharedPreferences?.setString(_realName(name), value);
  }

  void setStringList(String name, List<String> value) {
    _sharedPreferences?.setStringList(_realName(name), value);
  }

  void remove(String name) {
    _sharedPreferences?.remove(_realName(name));
  }
}
