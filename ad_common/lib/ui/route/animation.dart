import 'package:flutter/material.dart';

enum PageTransitionType {
  // 缩放动画
  scale,
  // 渐变透明
  fade,
  // 旋转
  rotate,
  // 从上到下
  top,
  // 从左到右
  left,
  // 从下到上
  bottom,
  // 从右到左
  right,
  // 无动画
  none,
}

//缩放路由动画
class ScaleRouter<T> extends PageRouteBuilder<T> {
  final Widget? page;
  final int duration;
  final Curve curve;
  final RouteSettings settings;

  ScaleRouter({
    this.page,
    this.duration = 300,
    required this.settings,
    this.curve = Curves.easeOut,
  }) : super(
            pageBuilder: (context, animation, secondaryAnimation) => page!,
            transitionDuration: Duration(milliseconds: duration),
            transitionsBuilder: (context, a1, a2, child) => ScaleTransition(
                  scale: Tween(begin: 0.0, end: 1.0)
                      .animate(CurvedAnimation(parent: a1, curve: curve)),
                  child: child,
                ),
            settings: settings);
}

//渐变透明路由动画
class FadeRouter<T> extends PageRouteBuilder<T>  {
  final Widget? page;
  final int duration;
  final Curve curve;
  final RouteSettings settings;

  FadeRouter({
    this.page,
    this.duration = 300,
    this.curve = Curves.easeOut,
    required this.settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page!,
          transitionDuration: Duration(milliseconds: duration),
          transitionsBuilder: (context, a1, a2, child) => FadeTransition(
            opacity: Tween(begin: 0.1, end: 1.0).animate(CurvedAnimation(
              parent: a1,
              curve: curve,
            )),
            child: child,
          ),
          settings: settings,
        );
}

//旋转路由动画
class RotateRouter<T>  extends PageRouteBuilder<T>  {
  final Widget? page;
  final int duration;
  final Curve curve;
  final RouteSettings settings;

  RotateRouter({
    this.page,
    this.duration = 300,
    this.curve = Curves.easeOut,
    required this.settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page!,
          transitionDuration: Duration(milliseconds: duration),
          transitionsBuilder: (context, a1, a2, child) => RotationTransition(
            turns: Tween(begin: 0.1, end: 1.0).animate(CurvedAnimation(
              parent: a1,
              curve: curve,
            )),
            child: child,
          ),
          settings: settings,
        );
}

//上--->下
class TopBottomRouter<T>  extends PageRouteBuilder<T>  {
  final Widget? page;
  final int duration;
  final Curve curve;
  final RouteSettings settings;

  TopBottomRouter({
    this.page,
    this.duration = 300,
    this.curve = Curves.fastOutSlowIn,
    required this.settings,
  }) : super(
          transitionDuration: Duration(milliseconds: duration),
          pageBuilder: (ctx, a1, a2) {
            return page!;
          },
          transitionsBuilder: (
            ctx,
            a1,
            a2,
            Widget child,
          ) {
            return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0.0, -1.0),
                  end: Offset(0.0, 0.0),
                ).animate(CurvedAnimation(parent: a1, curve: curve)),
                child: child);
          },
          settings: settings,
        );
}

//左--->右
class LeftRightRouter<T> extends PageRouteBuilder<T> {
  final Widget? page;
  final int duration;
  final Curve curve;
  final RouteSettings settings;

  LeftRightRouter({
    this.page,
    this.duration = 300,
    this.curve = Curves.easeOut,
    required this.settings,
  })  : assert(true),
        super(
          transitionDuration: Duration(milliseconds: duration),
          pageBuilder: (ctx, a1, a2) {
            return page!;
          },
          transitionsBuilder: (
            ctx,
            a1,
            a2,
            Widget child,
          ) {
            return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(-1.0, 0.0),
                  end: Offset(0.0, 0.0),
                ).animate(CurvedAnimation(parent: a1, curve: curve)),
                child: child);
          },
          settings: settings,
        );
}

//下--->上
class BottomTopRouter<T>  extends PageRouteBuilder<T>  {
  final Widget? page;
  final int duration;
  final Curve curve;
  final RouteSettings settings;

  BottomTopRouter({
    this.page,
    this.duration = 300,
    this.curve = Curves.easeOut,
    required this.settings,
  }) : super(
          transitionDuration: Duration(milliseconds: duration),
          pageBuilder: (ctx, a1, a2) {
            return page!;
          },
          transitionsBuilder: (
            ctx,
            a1,
            a2,
            Widget child,
          ) {
            return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0.0, 1.0),
                  end: Offset(0.0, 0.0),
                ).animate(CurvedAnimation(parent: a1, curve: curve)),
                child: child);
          },
          settings: settings,
        );
}

//右--->左
class RightLeftRouter<T> extends PageRouteBuilder<T> {
  final Widget? page;
  final int duration;
  final Curve curve;
  final RouteSettings settings;

  RightLeftRouter({
    this.page,
    this.duration = 300,
    this.curve = Curves.easeOut,
    required this.settings,
  }) : super(
          transitionDuration: Duration(milliseconds: duration),
          pageBuilder: (ctx, a1, a2) {
            return page!;
          },
          transitionsBuilder: (
            ctx,
            a1,
            a2,
            Widget child,
          ) {
            return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(1.0, 0.0),
                  end: Offset(0.0, 0.0),
                ).animate(CurvedAnimation(parent: a1, curve: curve)),
                child: child);
          },
          settings: settings,
        );
}

//缩放+透明+旋转路由动画
class ScaleFadeRotateRouter<T> extends PageRouteBuilder<T> {
  final Widget? page;
  final int duration;
  final Curve curve;

  ScaleFadeRotateRouter({
    this.page,
    this.duration = 300,
    this.curve = Curves.fastOutSlowIn,
  }) : super(
            transitionDuration: Duration(milliseconds: duration),
            pageBuilder: (ctx, a1, a2) => page!, //页面
            transitionsBuilder: (
              ctx,
              a1,
              a2,
              Widget child,
            ) {
              //构建动画
              return RotationTransition(
                //旋转动画
                turns: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: a1,
                  curve: curve,
                )),
                child: ScaleTransition(
                  //缩放动画
                  scale: Tween(begin: 0.0, end: 1.0)
                      .animate(CurvedAnimation(parent: a1, curve: curve)),
                  child: FadeTransition(
                    opacity: //透明度动画
                        Tween(begin: 0.5, end: 1.0)
                            .animate(CurvedAnimation(parent: a1, curve: curve)),
                    child: child,
                  ),
                ),
              );
            });
}

//无动画
class NoAnimRouter<T> extends PageRouteBuilder<T> {
  final Widget? page;
  final RouteSettings settings;
  NoAnimRouter({this.page, required this.settings})
      : super(
            opaque: false,
            settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) => page!,
            transitionDuration: Duration(milliseconds: 0),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) => child);
}
