import 'dart:async';
import 'package:dio/dio.dart';

///网络请求-头部拦截器
class HeaderInterceptor extends InterceptorsWrapper {
  /// 添加Header拦截器 <br/>
  addHeaderInterceptors(RequestOptions options) async {}

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    return options;
  }
}
