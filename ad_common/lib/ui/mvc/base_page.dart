import 'package:ad_common/common/global/network_state_listener.dart';
import 'package:ad_common/ui/mvc/page_state_widget.dart';
import 'package:ad_common/ui/widget/nav_bar.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'base_controller.dart';

abstract class BasePageState<T extends StatefulWidget, C extends BaseController>
    extends State<T> implements PageInterface {
  C controller;

  @override
  void initState() {
    controller.initLoad();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => controller.widgetDidLoad());
    super.initState();
  }

  @override
  void dispose() {
    controller.widgetDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return renderLayout();
  }

  Widget get body {
    return statePage;
  }

  Widget get statePage {
    final state = controller.switchState();
    switch (state) {
      case PageStateType.content:
        return content;
      case PageStateType.loading:
        return load;
      case PageStateType.error:
        return error;
      case PageStateType.empty:
        return empty;
    }
    return content;
  }

  @override
  Widget get empty => PageStateEmpty(onRetry: controller.loadRetry);

  @override
  Widget get error {
    if (NetworkState().state == ConnectivityResult.none) {
      return PageStateNetWorkError(
        onRetry: controller.loadRetry,
      );
    } else {
      return PageStateRequestError(
        onRetry: controller.loadRetry,
      );
    }
  }

  @override
  Widget get load => PageStateLoad();

  @override
  Widget get navigation => NavBar();

  @override
  Widget get bottomNavigationBar => null;

  Color get backgroundColor => Colors.white;

  bool get extendBodyBehindAppBar => false;

  /// 状态栏颜色
  SystemUiOverlayStyle get style => SystemUiOverlayStyle.dark;

  /// 渲染视图
  Widget renderLayout() {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: style,
      child: ChangeNotifierProvider.value(
        value: controller,
        child: Consumer<C>(
          builder: (context, controller, _) {
            return WillPopScope(
              onWillPop: controller.onWillPop,
              child: Scaffold(
                backgroundColor: backgroundColor,
                extendBodyBehindAppBar: extendBodyBehindAppBar,
                appBar: navigation,
                body: body,
                bottomNavigationBar: bottomNavigationBar,
              ),
            );
          },
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
abstract class BasePage<T extends BaseController> extends StatelessWidget
    implements PageInterface {
  T controller;

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: style,
      child: ChangeNotifierProvider.value(
        value: controller,
        child: Consumer<T>(
          builder: (context, controller, _) {
            return renderLayout();
          },
        ),
      ),
    );
  }

  @override
  Widget get body {
    switch (controller.switchState()) {
      case PageStateType.content:
        return content;
      case PageStateType.error:
        return error;
      case PageStateType.empty:
        return empty;
      case PageStateType.loading:
        return load;
    }
    return content;
  }

  @override
  Widget get empty => PageStateEmpty(
        onRetry: controller.loadRetry,
      );

  @override
  Widget get error {
    if (NetworkState().state == ConnectivityResult.none) {
      return PageStateNetWorkError(
        onRetry: controller.loadRetry,
      );
    } else {
      return PageStateRequestError(
        onRetry: controller.loadRetry,
      );
    }
  }

  @override
  Widget get load => PageStateLoad();

  @override
  Widget get navigation => NavBar();

  @override
  Widget get bottomNavigationBar => null;

  Color get backgroundColor => Colors.white;

  SystemUiOverlayStyle get style => SystemUiOverlayStyle.dark;

  Widget renderLayout() {
    return WillPopScope(
      onWillPop: controller.onWillPop,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: navigation,
        body: GestureDetector(
          onTap: controller.onScreenClick,
          child: body,
        ),
      ),
    );
  }
}

abstract class BaseBodyPageState<T extends StatefulWidget, C extends BaseController>
    extends State<T> implements PageInterface {
  C controller;

  @override
  void initState() {
    controller.initLoad();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => controller.widgetDidLoad());
    super.initState();
  }

  @override
  void dispose() {
    controller.widgetDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return renderLayout();
  }

  Widget get body {
    return statePage;
  }

  Widget get statePage {
    final state = controller.switchState();
    switch (state) {
      case PageStateType.content:
        return content;
      case PageStateType.loading:
        return load;
      case PageStateType.error:
        return error;
      case PageStateType.empty:
        return empty;
    }
    return content;
  }

  @override
  Widget get empty => PageStateEmpty(onRetry: controller.loadRetry);

  @override
  Widget get error {
    if (NetworkState().state == ConnectivityResult.none) {
      return PageStateNetWorkError(
        onRetry: controller.loadRetry,
      );
    } else {
      return PageStateRequestError(
        onRetry: controller.loadRetry,
      );
    }
  }

  @override
  Widget get load => PageStateLoad();

  @override
  Widget get navigation => null;

  @override
  Widget get bottomNavigationBar => null;

  Color get backgroundColor => Colors.white;

  bool get extendBodyBehindAppBar => false;

  /// 状态栏颜色
  SystemUiOverlayStyle get style => SystemUiOverlayStyle.dark;

  /// 渲染视图
  Widget renderLayout() {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: style,
      child: ChangeNotifierProvider.value(
        value: controller,
        child: Consumer<C>(
          builder: (context, controller, _) {
            return WillPopScope(
              onWillPop: controller.onWillPop,
              child: body,
            );
          },
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
abstract class BaseBodyPage<T extends BaseController> extends StatelessWidget
    implements PageInterface {
  T controller;

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: style,
      child: ChangeNotifierProvider.value(
        value: controller,
        child: Consumer<T>(
          builder: (context, controller, _) {
            return renderLayout();
          },
        ),
      ),
    );
  }

  @override
  Widget get body {
    switch (controller.switchState()) {
      case PageStateType.content:
        return content;
      case PageStateType.error:
        return error;
      case PageStateType.empty:
        return empty;
      case PageStateType.loading:
        return load;
    }
    return content;
  }

  @override
  Widget get empty => PageStateEmpty(
        onRetry: controller.loadRetry,
      );

  @override
  Widget get error {
    if (NetworkState().state == ConnectivityResult.none) {
      return PageStateNetWorkError(
        onRetry: controller.loadRetry,
      );
    } else {
      return PageStateRequestError(
        onRetry: controller.loadRetry,
      );
    }
  }

  @override
  Widget get load => PageStateLoad();

  @override
  Widget get navigation => null;

  @override
  Widget get bottomNavigationBar => null;

  Color get backgroundColor => Colors.white;

  SystemUiOverlayStyle get style => SystemUiOverlayStyle.dark;

  Widget renderLayout() {
    return WillPopScope(
      onWillPop: controller.onWillPop,
      child: GestureDetector(
        onTap: controller.onScreenClick,
        child: body,
      ),
    );
  }
}

abstract class BaseBottomSheetDialog<T extends StatefulWidget,
    C extends BaseController> extends State<T> {
  C controller;

  Color get backgroundColor => Colors.grey[700];

  double get elevation => 24.0;

  RoundedRectangleBorder get dialogShape =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0));

  @override
  void initState() {
    controller.initLoad();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => controller.widgetDidLoad());
    super.initState();
  }

  @override
  void dispose() {
    controller.widgetDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return renderLayout();
  }

  /// 渲染视图
  Widget renderLayout() {
    final EdgeInsets effectivePadding =
        MediaQuery.of(context).viewInsets + const EdgeInsets.all(0.0);
    return AnimatedPadding(
      padding: effectivePadding,
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 280.0),
          child: Material(
            color: backgroundColor,
            elevation: elevation,
            shape: dialogShape,
            type: MaterialType.transparency,
            clipBehavior: Clip.none,
            child: ChangeNotifierProvider.value(
              value: controller,
              child: Consumer<C>(
                builder: (context, controller, _) {
                  return content;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get content;
}

abstract class PageInterface {
  Widget get content;

  Widget get error;

  Widget get empty;

  Widget get load;

  Widget get navigation;

  Widget get body;

  Widget get bottomNavigationBar;
}
