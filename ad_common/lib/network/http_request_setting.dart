import 'package:dio/dio.dart';

import 'log_interceptor.dart';

class HttpRequestSetting {

  /// 基础URL(host)
  final String baseUrl;

  /// 连接超时时间
  final int connectTimeOut;

  /// 响应超时时间
  final int receiveTimeOut;

  /// 请求日志控制
  final LogPrintInterceptor logPrintInterceptor;

  /// 请求拦截器
  final InterceptorsWrapper interceptorsWrapper;

  /// 请求内容编码
  final String contentType;

  /// 请求代理(测试环境)
  final String delegateHost;

  /// 请求记录(测试环境)
  final bool isRecordRequest;

  HttpRequestSetting({
    this.baseUrl = "",
    this.connectTimeOut = 10,
    this.receiveTimeOut = 15,
    this.logPrintInterceptor,
    this.interceptorsWrapper,
    this.contentType = "application/x-www-form-urlencoded",
    this.delegateHost,
    this.isRecordRequest = false,
  });
}
