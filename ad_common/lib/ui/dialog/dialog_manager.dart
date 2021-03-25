import 'package:ad_common/ui/route/animation.dart';
import 'package:flutter/material.dart';

/*
* 自定义动画展示dialog
* */
Future<T> showAnimationDialog<T>(
  BuildContext context, {
  @required Widget child,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
  RouteSettings routeSettings,
  PageTransitionType transitionType = PageTransitionType.scale,
}) {
  assert(useRootNavigator != null);
  assert(debugCheckHasMaterialLocalizations(context));

  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) =>
        child,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (context, animation1, animation2, child) {
      return _buildDialogTransitions(
          context, animation1, animation2, child, transitionType);
    },
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
  );
}

Widget _buildDialogTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    PageTransitionType type) {
  if (type == PageTransitionType.fade) {
    // 渐变效果
    return FadeTransition(
      // 从0开始到1
      opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        // 传入设置的动画
        parent: animation,
        // 设置效果，快进漫出   这里有很多内置的效果
        curve: Curves.fastOutSlowIn,
      )),
      child: child,
    );
  } else if (type == PageTransitionType.scale) {
    return ScaleTransition(
      scale: Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
      child: child,
    );
  } else if (type == PageTransitionType.left) {
    // 左右滑动动画效果
    return SlideTransition(
      position: Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))
          .animate(
              CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
      child: child,
    );
  } else if (type == PageTransitionType.right) {
    return SlideTransition(
      position: Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
          .animate(
              CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
      child: child,
    );
  } else if (type == PageTransitionType.top) {
    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))
          .animate(
              CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
      child: child,
    );
  } else if (type == PageTransitionType.bottom) {
    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
          .animate(
              CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
      child: child,
    );
  } else {
    return child;
  }
}
