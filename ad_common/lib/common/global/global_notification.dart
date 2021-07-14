

import 'package:ad_common/ad_common.dart';

/// 订阅者回调签名
typedef void NotificationCallback(arg);

/// 广播管理
class NotificationManager {
  factory NotificationManager() => _getInstance();
  static NotificationManager get instance => _getInstance();
  static NotificationManager _instance;
  NotificationManager._internal();

  static NotificationManager _getInstance() {
    if (_instance == null)_instance = new NotificationManager._internal();
    return _instance;
  }

  /// 保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  var _notificationQueue = new Map<Object, List<NotificationObject>>();

  /// 添加订阅者
  void add({Object name, Object bindObj,  NotificationCallback callback}) {
    if (name == null || callback == null || bindObj == null) return;
    if(_containsObj(name, bindObj) == -1){
      // 不存在 添加(防止重复添加)
      NotificationObject object = NotificationObject(object: bindObj, callback: callback);
      stLog("添加通知: name: ${name.toString()} 绑定对象: ${bindObj}");
      _notificationQueue[name] ??= [];
      _notificationQueue[name].add(object);
    }
  }

  /// 移除订阅者
  void remove({Object name, Object bindObj}) {
    if (bindObj == null || name == null) return;
    var list = _notificationQueue[name.toString()];
    if (name.toString() == null || list == null) return;
    int index = _containsObj(name, bindObj);
    if(index != -1) list.removeAt(index);
    stLog("移除通知: name: ${name.toString()} 移除对象: ${bindObj}");
    _notificationQueue[name.toString()] = list;
  }

  /// 删除通知
  void delete(Object name){
    if(name.toString() == null || name.toString().length <= 0) return;
    if(_notificationQueue.containsKey(name.toString())){
      stLog("删除通知: name: ${name.toString()}");
      _notificationQueue.remove(name.toString());
    }
  }

  /// 触发事件，事件触发后该事件所有订阅者会被调用
  void send({Object name, arg}) {
    var list = _notificationQueue[name.toString()];
    if (list == null) return;
    list.forEach((element) {
      stLog("发送通知: name: ${name.toString()} 发送对象: ${element}");
      element.callback(arg);
    });
  }

  /// 是否已经存在通知绑定对象
  int _containsObj(Object name, Object obj){
    if (obj == null) return -1;
    var list = _notificationQueue[name.toString()];
    if (name.toString() == null || list == null) return -1;
    int index = -1;
    for(int i = 0; i< list.length; i++){
      NotificationObject notification = list[i];
      if(identical(notification.object, obj)){
        index = i;
        break;
      }
    }
    return index;
  }

}

class NotificationObject {
  Object object;
  NotificationCallback callback;
  NotificationObject({this.object, this.callback});
}
