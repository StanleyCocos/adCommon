import 'dart:async';
import 'package:dio/dio.dart';


class HeaderInterceptor extends InterceptorsWrapper {
  /// 添加Header拦截器 <br/>
  addHeaderInterceptors(RequestOptions options) async {

  }

  @override
  Future onRequest(RequestOptions options) async {

    return options;
  }
}
