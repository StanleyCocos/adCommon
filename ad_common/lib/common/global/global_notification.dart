/// 订阅者回调签名
typedef void NotificationCallback(arg);

/// 广播管理
class NotificationManager {
  factory NotificationManager() => _getInstance();

  static NotificationManager get instance => _getInstance();
  static NotificationManager _instance;

  NotificationManager._internal();

  static NotificationManager _getInstance() {
    if (_instance == null) {
      _instance = new NotificationManager._internal();
    }
    return _instance;
  }

  /// 保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  var _notificatio_queue = new Map<Object, List<NotificationCallback>>();

  /// 添加订阅者
  void add(String name, NotificationCallback f) {
    if (name.toString() == null || f == null) return;
    _notificatio_queue[name] ??= new List<NotificationCallback>();
    _notificatio_queue[name].add(f);
  }

  /// 移除订阅者
  void remove(String name, [NotificationCallback f]) {
    var list = _notificatio_queue[name.toString()];
    if (name.toString() == null || list == null) return;
    if (f == null) {
      _notificatio_queue[name] = null;
    } else {
      list.remove(f);
    }
  }

  /// 触发事件，事件触发后该事件所有订阅者会被调用
  void send(String name, [arg]) {
    var list = _notificatio_queue[name];
    if (list == null) return;
    int len = list.length - 1;
    //反向遍历，防止在订阅者在回调中移除自身带来的下标错位
    for (var i = len; i > -1; --i) {
      list[i](arg);
    }
  }
}
