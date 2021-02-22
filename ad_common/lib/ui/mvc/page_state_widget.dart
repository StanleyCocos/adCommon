import 'dart:io';

import 'package:ad_common/ui/util/color_manager.dart';
import 'package:ad_common/ui/widget/common_state_page.dart';
import 'package:ad_common/ui/widget/image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class BasePageStateWidget extends StatelessWidget {
  final Function onRetry;
  final String text;
  final String type;
  final double width;
  final double height;

  BasePageStateWidget({
    this.onRetry,
    this.text = "",
    this.type,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) => renderLayout();

  Widget renderLayout() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: InkWell(
        onTap: () => onRetry(),
        child: CommonStatePage(
          image: ImageManager.name(
            this.type,
            path: "placeholder/",
            width: width,
            height: height,
            fit: BoxFit.contain,
          ),
          text: text,
        ),
      ),
    );
  }
}

/// 网络错误
class PageStateNetWorkError extends BasePageStateWidget {
  PageStateNetWorkError({String text, Function onRetry})
      : super(
          onRetry: onRetry,
          text: text ?? "網路不順，請檢查後再重試",
          type: "",
          width: ScreenUtil().setWidth(620),
          height: ScreenUtil().setWidth(410),
        );
}

/// 请求错误
class PageStateRequestError extends BasePageStateWidget {
  PageStateRequestError({String text, Function onRetry})
      : super(
          onRetry: onRetry,
          text: text ?? "請求錯誤，請重試",
          type: "",
          width: ScreenUtil().setWidth(620),
          height: ScreenUtil().setWidth(420),
        );
}

/// 空页面
class PageStateEmpty extends BasePageStateWidget {
  PageStateEmpty({String text, Function onRetry})
      : super(
          onRetry: onRetry,
          text: text ?? "暫無數據",
          type: "",
          width: ScreenUtil().setWidth(620),
          height: ScreenUtil().setWidth(350),
        );
}

/// 默认加载页
class PageStateLoad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          indicator,
          Padding(
            padding: EdgeInsets.only(
              top: 20,
            ),
          ),
          Text(
            "裝載中...",
            style: TextStyle(
              fontSize: ScreenUtil().setSp(28),
            ),
          ),
        ],
      ),
    );
  }

  Widget get indicator {
    return Platform.isIOS
        ? CupertinoActivityIndicator(
            animating: true,
            radius: 12.0,
          )
        : CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation(ColorManager.gray99),
          );
  }
}


