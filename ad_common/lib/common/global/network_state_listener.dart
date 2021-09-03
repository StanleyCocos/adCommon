import 'dart:async';

import 'package:connectivity/connectivity.dart';

class NetworkState {
  /// 工厂模式创建单例
  factory NetworkState() => _getInstance()!;
  static NetworkState? _instance;
  NetworkState._internal();

  static NetworkState? _getInstance() {
    if (_instance == null) _instance = NetworkState._internal();
    return _instance;
  }

  StreamSubscription<ConnectivityResult>? subscription;
  ConnectivityResult? _state;

  void startListen() {
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _state = result;
    });
  }

  void stopListen() {
    subscription?.cancel();
  }

  Future<ConnectivityResult> check() async {
    return await (Connectivity().checkConnectivity());
  }

  get state => _state;
}
