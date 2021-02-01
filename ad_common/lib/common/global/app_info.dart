import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:ad_common/common/extension/string_extension.dart';
import 'package:package_info/package_info.dart';
import 'package:uuid/uuid.dart';

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

  String get androidId => _androidId;

  /// 设备系统版本
  String get systemVersion => _systemVersion;

  factory AppInfoManager() => _getInstance();

  static AppInfoManager get instance => _getInstance();
  static AppInfoManager _instance;
  static const String IMEI_KEY = "designUUID";

  AppInfoManager._internal() {
    initInfo();
  }

  static AppInfoManager _getInstance() {
    if (_instance == null) {
      _instance = new AppInfoManager._internal();
    }
    return _instance;
  }

  Future<String> getImei() async {
    var content = await FlutterKeychain.get(key: IMEI_KEY);
    if (!content.isEmptyOrNull) {
      content = content.replaceAll("\n", "");
      return content.toLowerCase();
    }
    return "";
  }

  Future<String> _setImei(String imei) async {
    FlutterKeychain.put(key: IMEI_KEY, value: imei);
  }

  Future initInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      _mode = DeviceMode.transform(iosInfo.utsname.machine);
      _versionCode = packageInfo.buildNumber;
      _version = packageInfo.version;
      _imei = await getImei();
      if (_imei.isEmptyOrNull) {
        _setImei(iosInfo.identifierForVendor);
        _imei = iosInfo.identifierForVendor;
      }
      _systemVersion = iosInfo.systemVersion;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      _mode = androidInfo.model;
      _versionCode = packageInfo.buildNumber;
      _version = packageInfo.version;
      _systemVersion = androidInfo.version.release;
      _imei = await getImei();
      _androidId = androidInfo.androidId;
      if (_imei.isEmptyOrNull) {
        _setImei(Uuid().v4());
        _imei = await getImei();
      }
    }
  }

  String userAgent() {
    return "version/$version" +
        " version_code/$versionCode" +
        " clients/${Platform.isIOS ? "iOS" : "Android"}" +
        " imei/$imei" +
        " model/${mode.replaceAll(" ", "-").toLowerCase()}" +
        " system/${_systemVersion.replaceAll(" ", "-")}" +
        " framework/flutter" +
        " image/webp";
  }

  String _mode = "";
  String _version = "";
  String _versionCode = "";
  String _imei = "";
  String _androidId = "";
  String _systemVersion = "";
}

class DeviceMode {
  static String transform(String mode) {
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
        default:
          return mode;
      }
    } else {
      return mode;
    }
  }
}