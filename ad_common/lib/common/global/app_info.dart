import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:ad_common/common/extension/string_extension.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:package_info_plus/package_info_plus.dart';

///app信息管理类
class AppInfoManager {
  /// 版本
  String get version => _version;

  /// 设备类型
  String get mode => _mode;

  /// 版本号
  String get versionCode => _versionCode;

  /// 唯一标识
  String get imei => _imei;

  ///设备标识
  String get identifier => _identifier;

  /// 设备系统版本
  String get systemVersion => _systemVersion;

  String _mode = "";
  String _version = "";
  String _versionCode = "";
  String _imei = "";
  String _identifier = "";
  String _systemVersion = "";

  factory AppInfoManager() => _getInstance();
  static AppInfoManager? _instance;
  static const String IMEI_KEY = "designUUID";

  AppInfoManager._internal();

  static AppInfoManager _getInstance() {
    _instance ??= AppInfoManager._internal();
    return _instance!;
  }

  Future<String> _getImei() async {
    try {
      var content = await FlutterKeychain.get(key: IMEI_KEY);
      if (!content.isEmptyOrNull) {
        content = content!.replaceAll("\n", "");
        return content.toLowerCase();
      }
      return "";
    } catch (e) {
      return "";
    }
  }

  Future<void> _setImei(String imei) async {
    return FlutterKeychain.put(key: IMEI_KEY, value: imei);
  }

  Future initInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      _mode = DeviceMode.transform(iosInfo.utsname.machine ?? "") ?? "";
      _versionCode = packageInfo.buildNumber;
      _version = packageInfo.version;
      _imei = await _getImei();
      if (_imei.isEmptyOrNull || _imei.length <= 10) {
        // 修复之前可能存在字符串 null的imei
        _identifier = iosInfo.identifierForVendor ?? _imeiBuilder();
        if(_identifier.length <= 10) _identifier = _imeiBuilder();
        _imei = _identifier.toLowerCase();
        _setImei(_imei);
      }
      _systemVersion = iosInfo.systemVersion ?? "";
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      _mode = androidInfo.model ?? "";
      _versionCode = packageInfo.buildNumber;
      _version = packageInfo.version;
      _systemVersion = androidInfo.version.release ?? "";
      _imei = await _getImei();
      if (_imei.isEmptyOrNull || _imei.length <= 10) {
        // 修复之前可能存在字符串 null的imei
        _identifier = androidInfo.androidId ?? "";
        _imei = _generateUUID() ?? _imeiBuilder();
        if(_imei.length <= 10) _imei = _imeiBuilder();
        _imei = _imei.toLowerCase();
        _setImei(_imei);
      }
    }
  }

  String? _generateUUID() {
    if (_identifier.length <= 0) return null;
    var androidId = Utf8Encoder().convert(_identifier);
    String uuid = md5.convert(androidId).toString();
    if (uuid.length != 32) return null;
    StringBuffer sb = StringBuffer();
    sb.write(uuid.substring(0, 8));
    sb.write("-");
    sb.write(uuid.substring(8, 12));
    sb.write("-");
    sb.write(uuid.substring(12, 16));
    sb.write("-");
    sb.write(uuid.substring(16, 20));
    sb.write("-");
    sb.write(uuid.substring(20, 32));
    return sb.toString();
  }

  String _imeiBuilder() {
    StringBuffer sb = StringBuffer();
    sb.write(_builderRandom(8));
    sb.write("-");
    sb.write(_builderRandom(4));
    sb.write("-");
    sb.write(_builderRandom(4));
    sb.write("-");
    sb.write(_builderRandom(4));
    sb.write("-");
    sb.write(_builderRandom(12));
    return sb.toString();
  }

  String _builderRandom(int length) {
    var _chars = "abcdef0123456789";
    var imei = String.fromCharCodes(
      Iterable.generate(
        length,
        (_){
          return _chars.codeUnitAt(
            Random().nextInt(_chars.length),
          );
        },
      ),
    );
    return imei.replaceRange(0, 1, "x");
  }
}

class DeviceMode {
  static String? transform(String mode) {
    if (Platform.isIOS) {
      switch (mode) {
        case "iPhone4,1":
          return "iPhone 4S";
        case "iPhone5,1":
          return "iPhone 5";
        case "iPhone5,2":
          return "iPhone 5";
        case "iPhone5,3":
          return "iPhone 5c";
        case "iPhone5,4":
          return "iPhone 5c";
        case "iPhone6,1":
          return "iPhone 5s";
        case "iPhone6,2":
          return "iPhone 5s";
        case "iPhone7,1":
          return "iPhone 6 Plus";
        case "iPhone7,2":
          return "iPhone 6";
        case "iPhone8,1":
          return "iPhone 6s";
        case "iPhone8,2":
          return "iPhone 6s Plus";
        case "iPhone8,4":
          return "iPhone SE";
        case "iPhone9,1":
          return "iPhone 7";
        case "iPhone9,2":
          return "iPhone 7 Plus";
        case "iPhone9,3":
          return "iPhone 7";
        case "iPhone9,4":
          return "iPhone 7 Plus";
        case "iPhone10,1":
          return "iPhone 8";
        case "iPhone10,4":
          return "iPhone 8";
        case "iPhone10,2":
          return "iPhone 8 Plus";
        case "iPhone10,5":
          return "iPhone 8 Plus";
        case "iPhone10,3":
          return "iPhone X";
        case "iPhone10,6":
          return "iiPhone X";
        case "iPhone11,8":
          return "iPhone XR";
        case "iPhone11,2":
          return "iPhone XS";
        case "iPhone11,6":
          return "iPhone XS Max";
        case "iPhone11,4":
          return "iPhone XS Max";
        case "iPhone12,1":
          return "iPhone 11";
        case "iPhone12,3":
          return "iPhone 11 Pro";
        case "iPhone12,5":
          return "iPhone 11 Pro Max";
        case "iPhone12,8":
          return "iPhone SE";
        case "iPhone13,1":
          return "iPhone 12 mini";
        case "iPhone13,2":
          return "iPhone 12";
        case "iPhone13,3":
          return "iPhone 12 Pro";
        case "iPhone13,4":
          return "iPhone 12 Pro Max";
        case "iPhone14,4":
          return "iPhone 13 mini";
        case "iPhone14,5":
          return "iPhone 13";
        case "iPhone14,2":
          return "iPhone 13 Pro";
        case "iPhone14,3":
          return "iPhone 13 Pro Max";
        default:
          return mode;
      }
    } else {
      return mode;
    }
  }
}
