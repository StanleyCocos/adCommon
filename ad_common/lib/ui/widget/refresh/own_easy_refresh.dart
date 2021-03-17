
import 'package:ad_common/ad_common.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:flutter/cupertino.dart';

class OwnEasyRefresh extends StatelessWidget {
  /// 是否开启控制结束刷新
  final bool enableControlFinishRefresh;

  /// 是否开启控制结束加载
  final bool enableControlFinishLoad;

  /// 顶部回弹(onRefresh为null时生效)
  final bool topBouncing;

  /// 底部回弹(onLoad为null时生效)
  final bool bottomBouncing;

  /// 控制器
  final EasyRefreshController controller;

  /// 刷新回调(null为不开启刷新)
  final Function onRefresh;

  /// 加载回调(null为不开启加载)
  final Function onLoad;

  /// 子组件
  final Widget child;

  /// Header
  final Header header;

  /// Footer
  final Footer footer;

  /// 默认构造器
  /// 将child转换为CustomScrollView可用的slivers
  OwnEasyRefresh({
    key,
    this.enableControlFinishRefresh = true,
    this.enableControlFinishLoad = true,
    this.topBouncing = true,
    this.bottomBouncing = true,
    this.controller,
    this.onRefresh,
    this.onLoad,
    this.header,
    this.footer,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      enableControlFinishRefresh: enableControlFinishRefresh,
      enableControlFinishLoad: enableControlFinishLoad,
      topBouncing: topBouncing,
      bottomBouncing: bottomBouncing,
      taskIndependence: true,
      header: header ??
          BallPulseHeader(
            color: ColorManager.gray33,
          ),
      footer: footer ??
          BallPulseFooter(
            color: ColorManager.gray33,
          ),
      controller: controller,
      onRefresh: onRefresh == null
          ? null
          : () async {
              onRefresh();
            },
      onLoad: onLoad == null
          ? null
          : () async {
              onLoad();
            },
      child: child,
    );
  }
}
