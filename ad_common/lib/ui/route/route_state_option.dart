import 'package:flutter/cupertino.dart';

abstract class BaseRouteOption {
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {}

  void didStartUserGesture(
      Route<dynamic> route, Route<dynamic>? previousRoute) {}

  void didStopUserGesture() {}
}
