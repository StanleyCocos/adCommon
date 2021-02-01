import 'package:ad_common/ui/route/route_state_option.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum RouteAction { PUSH, REPLACE, POP, REMOVE }

class RouteManager extends NavigatorObserver {
  /// 工厂模式创建单例
  factory RouteManager() => _getInstance();

  static RouteManager get instance => _getInstance();
  static RouteManager _instance;

  RouteManager._internal();

  static RouteManager _getInstance() {
    if (_instance == null) _instance = RouteManager._internal();
    return _instance;
  }

  /// 当前路由栈
  List<Route> _mRoutes = List<Route>();

  /// 当前路由
  Route get currentRoute => _mRoutes[_mRoutes.length - 1];

  List<BaseRouteOption> option = [];
  String homePageType = "";

  /// 跳转页面
  Future<Object> push(
    String routeName, {
    Object arguments,
    bool isReplace = false,
  }) {
    if (isReplace) {
      return navigator.pushReplacementNamed(routeName,
          arguments: arguments ?? "");
    } else {
      return navigator.pushNamed(routeName.toString(),
          arguments: arguments ?? "");
    }
  }

  /// 跳转页面
  Future<Object> pushRoute(Route route,
      {Object arguments, bool isReplace = false}) {
    if (isReplace) {
      return navigator.pushReplacement(route);
    } else {
      return navigator.push(route);
    }
  }

  /// 返回页面
  void pop<T extends Object>({String type, T result}) {
    if (!navigator.canPop()) return;
    if (_mRoutes.length <= 0 || _mRoutes.last.settings.name == "/") return;
    if (type == null) {
      navigator.pop(result);
    } else {
      navigator.popUntil((Route<dynamic> route) {
        if (route.settings.name == homePageType) {
          return true;
        } else {
          return type.toString() == route.settings.name;
        }
      });
    }
  }

  bool isCurrentRoute(String pageType) {
    return currentRoute.settings.name == pageType.toString();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPush(route, previousRoute);
    _mRoutes.add(route);
    PaintingBinding.instance.imageCache.clearLiveImages();
    option.forEach((e) => e.didPush(route, previousRoute));
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPop(route, previousRoute);
    _mRoutes.remove(route);
    PaintingBinding.instance.imageCache.clearLiveImages();
    option.forEach((e) => e.didPop(route, previousRoute));
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didRemove(route, previousRoute);
    PaintingBinding.instance.imageCache.clearLiveImages();
    option.forEach((e) => e.didRemove(route, previousRoute));
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _mRoutes.last = newRoute;
    PaintingBinding.instance.imageCache.clearLiveImages();
    option.forEach((e) => e.didReplace(newRoute: newRoute, oldRoute: oldRoute));
  }

  @override
  void didStartUserGesture(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didStartUserGesture(route, previousRoute);
    PaintingBinding.instance.imageCache.clearLiveImages();
    option.forEach((e) => e.didStartUserGesture(route, previousRoute));
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
    PaintingBinding.instance.imageCache.clearLiveImages();
    option.forEach((e) => e.didStopUserGesture());
  }
}
