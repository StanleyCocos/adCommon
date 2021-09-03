import 'package:ad_common/network/http_request.dart';
import 'package:ad_common/ui/route/animation.dart';
import 'package:ad_common/ui/route/route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'base_model.dart';

abstract class BaseController<T extends BaseModel> extends ChangeNotifier
    implements
        BaseControllerState,
        BaseControllerLifeCycle,
        BaseControllerCommonMethod {
  /// 模型 数据提供
  T? model;

  /// 当前页面上下文
  BuildContext? context;

  /// 是否加载中
  @override
  bool get loading => isLoadFirst;

  /// 是否页面错误
  @override
  bool get error => isLoadError;

  /// 是否空页面
  @override
  bool get empty => false;

  /// 是否正常显示内容
  @override
  bool get content => false;

  /// 是否需要控制点击屏幕任意位置 隐藏键盘
  bool get isHideKeyboard => true;

  /// 是否第一次加载
  bool isLoadFirst = true;

  /// 是否加载错误
  bool isLoadError = false;

  /// 视图渲染完成(只调用一次)
  @override
  void widgetDidLoad() {}

  /// 视图销毁
  @override
  void widgetDispose() {}

  /// 页面开始加载(只调用一次)
  @override
  void initLoad() {
    initRouteArguments();
  }

  /// 初始化路由参数
  @override
  void initRouteArguments() {}

  /// 当前路由点击后退
  @override
  void onNavigationBackClick() {
    RouteManager().pop();
  }

  /// 隐藏键盘
  @override
  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// 屏幕点击
  @override
  void onScreenClick() {
    if (isHideKeyboard) hideKeyboard();
  }

  /// 点击重新请求
  void loadRetry() {}

  /// 获取页面状态
  PageStateType switchState() {
    if (content) return PageStateType.content;
    if (loading) {
      isLoadFirst = false;
      return PageStateType.loading;
    }
    if (error) return PageStateType.error;
    if (empty) return PageStateType.empty;
    return PageStateType.content;
  }

  /// 获取页面间传递的参数
  Object? getArgument(Object key, {Object? defaultValue}) {
    final arguments = RouteManager().currentRoute!.settings.arguments;
    if (arguments == null) return defaultValue;
    if (arguments is Map) {
      final value = arguments[key];
      if (value == null) return defaultValue;
      return arguments[key];
    }
    return defaultValue;
  }
}

extension PageJump on BaseController {
  Future<Object?> push(
    Widget page, {
    Object? arguments,
    bool isReplace = false,
    PageTransitionType type = PageTransitionType.right,
  }) {
    var route =
        RouteManager().routeBuild(page: page, type: type, arguments: arguments);
    return RouteManager()
        .pushRoute(route, arguments: arguments, isReplace: isReplace);
  }

  void pop<T>({type, T? result}) {
    return RouteManager().pop(type: type, result: result);
  }
}

abstract class BaseStateController<T extends BaseModel, B extends BaseBean>
    extends BaseController<T> {
  /// 分页控制器
  final refreshController = EasyRefreshController();

  /// 分页 页码
  int loadPage = 1;

  /// 分页 每月数量(默认=0，由接口控制)
  int get pageSize => 0;

  /// 分页Api
  String get loadApi;

  /// 请求参数
  Map<String, Object> params = {"page": "1"};

  /// 是否v2接口
  bool get isV2Api => false;

  /// 解析器
  B get data;

  get _requestOptions => isV2Api
      ? Options(headers: {"Accept": "application/vnd.100design.v2+json"})
      : null;

  /// 加载列表 下拉刷新
  Future<void> loadListData() async {
    loadBegin(isRefresh: true);
    _setPageParams();
    await HttpRequest.getInstance()!.get(
      loadApi,
      params: params,
      options: _requestOptions,
      callBack: (data) {
        isLoadError = false;
        final B tempData = this.data;
        tempData.initJsonData(data);
        try {
          // 由于切换不同状态时 可能会把refresh视图干掉 这时这里会报异常
          refreshController.finishRefresh();
          refreshController.resetLoadState();
        } catch (e) {}
        loadSuccess(tempData, isRefresh: true);
      },
      errorCallBack: (error, code) {
        isLoadError = true;
        try {
          // 由于切换不同状态时 可能会把refresh视图干掉 这时这里会报异常
          refreshController.finishRefresh();
          refreshController.resetLoadState();
        } catch (e) {}
        loadError(error, isRefresh: true);
      },
      commonCallBack: () {
        loadCommon(isRefresh: true);
      },
    );
  }

  /// 加载列表 上拉加载更多
  Future<void> loadListDataMore() async {
    loadBegin(isRefresh: false);
    _setPageParams(isMore: true);
    await HttpRequest.getInstance()!.get(
      loadApi,
      params: params,
      options: _requestOptions,
      callBack: (data) {
        loadPage += 1;
        final B tempData = this.data;
        tempData.initJsonData(data);
        refreshController.finishLoad(noMore: tempData.listData.isEmpty);
        loadSuccess(tempData);
      },
      errorCallBack: (error, code) {
        refreshController.finishLoad(success: false);
        loadError(error);
      },
      commonCallBack: () => loadCommon(),
    );
  }

  /// 请求开始回调
  void loadBegin({bool isRefresh = false}) {}

  /// 请求成功回调
  void loadSuccess(B data, {bool isRefresh = false}) {}

  /// 请求失败回调
  void loadError(DioError? error, {bool isRefresh = false}) {}

  /// 请求始终回调
  void loadCommon({bool isRefresh = false}) {}

  /// 列表item点击
  void onItemClick<M>(M model, int index) {}

  /// 添加参数
  void addParams(Map<String, Object> params) {
    this.params.clear();
    this.params.addAll(params);
  }

  void _setPageParams({bool isMore = false}) {
    if (isMore) {
      params["page"] = "${loadPage + 1}";
    } else {
      loadPage = 1;
      params["page"] = "$loadPage";
    }
  }

  @override
  void loadRetry() {
    loadListData();
    super.loadRetry();
  }
}

/// 页面加载状态类型
enum PageStateType {
  /// 加载中
  loading,

  /// 空数据页面
  empty,

  /// 错误页面
  error,

  /// 真实数据内容
  content,
}

/// 页面加载状态
abstract class BaseControllerState {
  /// 是否展示加载布局
  bool get loading;

  /// 是否显示错误布局
  bool get error;

  /// 是否显示空布局
  bool get empty;

  /// 是否显示主内容
  bool get content;
}

/// 页面加载周期
abstract class BaseControllerLifeCycle {
  /// 开始加载
  void initLoad();

  /// 页面初始化完毕
  void widgetDidLoad();

  /// 页面销毁
  void widgetDispose();
}

/// 控制器常用方法
abstract class BaseControllerCommonMethod {
  /// 初始路由参数
  void initRouteArguments();

  /// 页面返回
  void onNavigationBackClick();

  /// 隐藏键盘
  void hideKeyboard();

  /// 页面body任意位置点击
  void onScreenClick();
}
