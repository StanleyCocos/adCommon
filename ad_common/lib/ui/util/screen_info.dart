import 'package:flutter/cupertino.dart';

class ScreenManager {
  ScreenManager._();

  static ScreenManager? _instance;

  factory ScreenManager() {
    if (_instance == null) _instance = ScreenManager._();
    return _instance!;
  }

  late Size _size;
  late double _width;
  late double _height;
  late double _navBarHeight;
  late double _bottomSafeHeight;
  late double _topSafeHeight;
  late double _navHeight;
  late double _shortestSide;
  late double _longestSide;
  late Orientation _orientation;
  late ScreenSize _screenSize;

  void initScreenParameter(BuildContext context) {
    _navHeight = 56;
    _size = MediaQuery.of(context).size;
    _width = _size.width;
    _height = _size.height;
    _navBarHeight = MediaQuery.of(context).padding.top + _navHeight;
    _bottomSafeHeight = MediaQuery.of(context).padding.bottom;
    _topSafeHeight = MediaQuery.of(context).padding.top;
    _shortestSide = _size.shortestSide;
    _longestSide = _size.longestSide;
    _orientation = MediaQuery.of(context).orientation;
    var aspectRatio = _longestSide / _shortestSide;
    if (aspectRatio < 16 / 9)
      _screenSize = ScreenSize.Small;
    else if (aspectRatio >= 16 / 9 && aspectRatio < 17 / 9)
      _screenSize = ScreenSize.Middle;
    else
      _screenSize = ScreenSize.Large;
  }

  Size get size => _size;
  double get width => _width;
  double get height => _height;
  double get navBarHeight => _navBarHeight;
  double get bottomSafeHeight => _bottomSafeHeight;
  double get topSafeHeight => _topSafeHeight;
  double get navHeight => _navHeight;
  double get shortestSide => _shortestSide;
  double get longestSide => _longestSide;
  Orientation get orientation => _orientation;
  ScreenSize get screenSize => _screenSize;
  double get safeArea => height - topSafeHeight - bottomSafeHeight;
  bool get isLargeScreen => screenSize == ScreenSize.Large;
  bool get isMiddleScreen => screenSize == ScreenSize.Middle;
  bool get isSmallScreen => screenSize == ScreenSize.Small;
}

enum ScreenSize { Large, Middle, Small }
