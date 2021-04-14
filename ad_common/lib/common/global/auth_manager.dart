import 'package:permission_handler/permission_handler.dart';

enum AuthType {
  /// 日历
  /// iOS: 支持
  /// Android: 支持
  Calendar,

  /// 相机
  /// iOS: 支持
  /// Android: 支持
  Camera,

  /// 相册
  /// iOS: 支持
  /// Android: 支持
  Photos,

  /// 通讯录
  /// iOS: 支持
  /// Android: 支持
  Contacts,

  /// 定位
  /// iOS: 支持
  /// Android: 支持
  Location,

  /// 麦克风
  /// iOS: 支持
  /// Android: 支持
  Microphone,

  /// 电话
  /// iOS: -
  /// Android: 支持
  Phone,

  /// 短信
  /// iOS: -
  /// Android: 支持
  Sms,

  /// 通知
  /// iOS: 支持
  /// Android: 支持
  Notification,

  /// 外部存储
  /// iOS: -
  /// Android: 支持
  Storage
}

typedef AuthStateCallback = void Function(PermissionStatus status);
typedef AuthErrorCallback = void Function(PermissionStatus status);
typedef AuthCheckCallback = void Function(bool status);

class Auth {
  static Future<PermissionStatus> request({
    AuthType type,
    AuthStateCallback callback,
    AuthErrorCallback errorCallback,
  }) async {
    PermissionStatus status;
    print(type);
    switch (type) {
      case AuthType.Calendar:
        status = await Permission.calendar.request();
        break;
      case AuthType.Camera:
        status = await Permission.camera.request();
        break;
      case AuthType.Photos:
        status = await Permission.photos.request();
        break;
      case AuthType.Contacts:
        status = await Permission.contacts.request();
        break;
      case AuthType.Location:
        status = await Permission.location.request();
        break;
      case AuthType.Microphone:
        status = await Permission.microphone.request();
        break;
      case AuthType.Phone:
        status = await Permission.phone.request();
        break;
      case AuthType.Sms:
        status = await Permission.sms.request();
        break;
      case AuthType.Notification:
        status = await Permission.notification.request();
        break;
      case AuthType.Storage:
        status = await Permission.storage.request();
        break;
    }
    if (status.isGranted) {
      if (callback != null) callback(status);
    } else {
      if (errorCallback != null) errorCallback(status);
    }
    return status;
  }

  static Future<bool> check({AuthType type, AuthCheckCallback callback}) async {
    PermissionStatus status;
    switch (type) {
      case AuthType.Calendar:
        status = await Permission.calendar.status;
        break;
      case AuthType.Camera:
        status = await Permission.camera.status;
        break;
      case AuthType.Photos:
        status = await Permission.photos.status;
        break;
      case AuthType.Contacts:
        status = await Permission.contacts.status;
        break;
      case AuthType.Location:
        status = await Permission.location.status;
        break;
      case AuthType.Microphone:
        status = await Permission.microphone.status;
        break;
      case AuthType.Phone:
        status = await Permission.phone.status;
        break;
      case AuthType.Sms:
        status = await Permission.sms.status;
        break;
      case AuthType.Notification:
        status = await Permission.notification.status;
        break;
      case AuthType.Storage:
        status = await Permission.storage.status;
        break;
    }
    if (callback != null) callback(status.isGranted);
    return status.isGranted;
  }

  static Future use({
    AuthType type,
    AuthStateCallback callback,
    AuthErrorCallback errorCallback,
  }) async {
    PermissionStatus status = await request(type: type);
    if (status.isGranted) {
      if (callback != null) callback(status);
    } else {
      if (errorCallback != null) errorCallback(status);
    }
  }
}
