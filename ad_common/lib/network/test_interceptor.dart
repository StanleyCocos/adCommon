import 'dart:convert';
import 'dart:io';

import 'package:ad_common/common/global/app_info.dart';
import 'package:dio/dio.dart';

import 'http_request.dart';

class ApiTestInterceptor extends InterceptorsWrapper {
  String get baseUrl => "http://101.133.142.11:8080";

  String get uploadUrl => "/api/history";

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    uploadToApiTest(
      url: err.requestOptions.uri.toString(),
      params: err.requestOptions.queryParameters,
      header: err.requestOptions.headers,
      method: err.requestOptions.method,
      responseCode: err.response?.statusCode,
      responseBody: err.response?.data,
    );
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    uploadToApiTest(
      url: response.requestOptions.uri.toString(),
      params: response.requestOptions.queryParameters,
      header: response.requestOptions.headers,
      method: response.requestOptions.method,
      responseCode: response.statusCode,
      responseBody: response.data,
    );
  }

  void uploadToApiTest({
    required String url,
    String? method,
    Map<String, dynamic>? params,
    Map<String, dynamic>? header,
    int? responseCode,
    dynamic responseBody,
  }) {
    if (url.startsWith(baseUrl)) return;

    // 将header转化为json可解析类型
    Map<String, dynamic> headerMap = {};
    header!.forEach((key, value) {
      headerMap[key] = value.toString();
    });

    String paramsStr = "";
    String headerStr = "";
    String responseBodyStr = "";
    try {
      paramsStr = jsonEncode(params);
      headerStr = jsonEncode(headerMap);
      responseBodyStr = jsonEncode(responseBody);
    } catch (JsonUnsupportedObjectError) {}

    HttpRequest.getInstance().post(
      "$baseUrl$uploadUrl",
      params: {
        "url": url,
        "method": method,
        "params": paramsStr,
        "hedaer": headerStr,
        "code": "${responseCode ?? ""}",
        "result": responseBodyStr,
        "client": Platform.isAndroid ? "Android" : "iOS",
        "imei": AppInfoManager().imei,
        "version": AppInfoManager().version,
      },
    );
  }
}
