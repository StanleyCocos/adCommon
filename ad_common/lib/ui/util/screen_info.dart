import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/screenutil.dart';


class ScreenManager {

  factory ScreenManager() => _getInstance();

  static ScreenManager get instance => _getInstance();
  static ScreenManager _instance;
  ScreenManager._internal();

  static ScreenManager _getInstance() {
    if (_instance == null) {
      _instance = new ScreenManager._internal();
    }
    return _instance;
  }

  Size _size;
  double _width;
  double _height;
  double _navBarHeight;
  double _bottomSafeHeight;
  double _topSafeHeight;
  double _navHeight;
  double _shortestSide;
  double _longestSide;
  Orientation _orientation;
  ScreenSize _screenSize;

  void initScreenParameter(BuildContext context){
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);
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
    if (aspectRatio < 16 / 9) _screenSize = ScreenSize.Small;
    else if (aspectRatio >= 16 / 9 && aspectRatio < 17 / 9) _screenSize = ScreenSize.Middle;
    else _screenSize = ScreenSize.Large;
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
}

enum ScreenSize { Large, Middle, Small }