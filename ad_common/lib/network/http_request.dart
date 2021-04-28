import 'dart:collection';
import 'package:ad_common/ad_common.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

import 'http_request_setting.dart';

typedef HttpRequestSuccessCallback = void Function(dynamic data);
typedef HttpRequestErrorCallback = void Function(DioError error, int stateCode);
typedef HttpRequestCommonCallback = void Function();

/// 可支持 restful 请求和普通API请求
///
/// GET、POST、DELETE、PATCH、PUT <br>
/// 主要作用为统一处理相关事务：<br>
///  - 统一处理请求前缀；<br>
///  - 统一打印请求信息；<br>
///  - 统一打印响应信息；<br>
///  - 统一打印报错信息；
class HttpRequest {
  static HttpRequest _instance;

  /// 请求方式
  static const String GET = "get";
  static const String POST = "post";
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';

  static HttpRequest getInstance() {
    if (_instance == null) {
      _instance = HttpRequest._internal();
    }
    return _instance;
  }

  Dio _client;

  Dio get client => _client;

  HttpRequestSetting _setting;

  HttpRequest._internal();

  /// 启动请求工具 并且设置请求参数
  void startAndSetRequestParams(HttpRequestSetting setting) {
    if (_client == null) {
      _setting = setting;
      BaseOptions options = new BaseOptions();
      options.connectTimeout = setting.connectTimeOut * 1000;
      options.receiveTimeout = setting.receiveTimeOut * 1000;
      options.baseUrl = setting.baseUrl;
      options.contentType = setting.contentType;
      _client = new Dio(options);
      _client.interceptors.add(setting.interceptorsWrapper);
      _client.interceptors.add(setting.logPrintInterceptor);
      if (isDebug && !setting.delegateHost.isEmptyOrNull) {
        (_client.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
          client.findProxy = (url) => setting.delegateHost;
        };
      }
    }
  }

  /// Get请求 <br/>
  ///
  /// @param [url] 请求地址 <br/>
  /// @param [params] 请求参数（可选） <br/>
  /// @param [callBack] 请求结果回调方法（可选） <br/>
  /// @param [errorCallBack] 出错回调（可选） <br/>
  /// @param [commonCallBack] 公共回调方法，成功和失败都会调用（可选） <br/>
  /// @param [token] 取消请求时使用的CancelToken（可选） <br/>
  Future<bool> get(
    String url, {
    Options options,
    Map<String, dynamic> params,
    HttpRequestSuccessCallback callBack,
    HttpRequestErrorCallback errorCallBack,
    HttpRequestCommonCallback commonCallBack,
    CancelToken token,
  }) async {
    return await _request(
      url,
      method: GET,
      options: options,
      params: params,
      callBack: callBack,
      errorCallBack: errorCallBack,
      commonCallBack: commonCallBack,
      token: token,
    );
  }

  /// Post请求 <br/>
  ///
  /// @param [url] 请求地址 <br/>
  /// @param [params] 请求参数（可选） <br/>
  /// @param [callBack] 请求结果回调方法（可选） <br/>
  /// @param [errorCallBack] 出错回调（可选） <br/>
  /// @param [commonCallBack] 公共回调方法，成功和失败都会调用（可选） <br/>
  /// @param [token] 取消请求时使用的CancelToken（可选） <br/>
  Future<bool> post(
    String url, {
    Options options,
    Map<String, dynamic> params,
    Map<String, dynamic> formData,
    HttpRequestSuccessCallback callBack,
    HttpRequestErrorCallback errorCallBack,
    HttpRequestCommonCallback commonCallBack,
    CancelToken token,
  }) async {
    return await _request(
      url,
      method: POST,
      options: options,
      params: params,
      formData: formData,
      callBack: callBack,
      errorCallBack: errorCallBack,
      commonCallBack: commonCallBack,
      token: token,
    );
  }

  /// DELETE请求 <br/>
  ///
  /// @param [url] 请求地址 <br/>
  /// @param [params] 请求参数（可选） <br/>
  /// @param [callBack] 请求结果回调方法（可选） <br/>
  /// @param [errorCallBack] 出错回调（可选） <br/>
  /// @param [commonCallBack] 公共回调方法，成功和失败都会调用（可选） <br/>
  /// @param [token] 取消请求时使用的CancelToken（可选） <br/>
  Future<bool> delete(
    String url, {
    Options options,
    Map<String, dynamic> params,
    HttpRequestSuccessCallback callBack,
    HttpRequestErrorCallback errorCallBack,
    HttpRequestCommonCallback commonCallBack,
    CancelToken token,
  }) async {
    return await _request(
      url,
      method: DELETE,
      options: options,
      params: params,
      callBack: callBack,
      errorCallBack: errorCallBack,
      commonCallBack: commonCallBack,
      token: token,
    );
  }

  /// PATCH请求 <br/>
  ///
  /// @param [url] 请求地址 <br/>
  /// @param [params] 请求参数（可选） <br/>
  /// @param [callBack] 请求结果回调方法（可选） <br/>
  /// @param [errorCallBack] 出错回调（可选） <br/>
  /// @param [commonCallBack] 公共回调方法，成功和失败都会调用（可选） <br/>
  /// @param [token] 取消请求时使用的CancelToken（可选） <br/>
  Future<bool> patch(
    String url, {
    Options options,
    Map<String, dynamic> params,
    HttpRequestSuccessCallback callBack,
    HttpRequestErrorCallback errorCallBack,
    HttpRequestCommonCallback commonCallBack,
    CancelToken token,
  }) async {
    return await _request(
      url,
      method: PATCH,
      options: options,
      params: params,
      callBack: callBack,
      errorCallBack: errorCallBack,
      commonCallBack: commonCallBack,
      token: token,
    );
  }

  /// Put上传 <br/>
  ///
  /// @param [url] 请求地址 <br/>
  /// @param [formData] 请求form表单数据（可选） <br/>
  /// @param [callBack] 请求结果回调方法（可选） <br/>
  /// @param [errorCallBack] 出错回调（可选） <br/>
  /// @param [commonCallBack] 公共回调方法，成功和失败都会调用（可选） <br/>
  /// @param [progressCallBack] 请求进度回调方法 <br/>
  /// @param [onReceiveProgress] 接收进度回调方法 <br/>
  /// @param [token] 取消请求时使用的CancelToken（可选） <br/>
  Future<bool> put(
    String url, {
    Options options,
    Map<String, dynamic> params,
    HttpRequestSuccessCallback callBack,
    HttpRequestErrorCallback errorCallBack,
    HttpRequestCommonCallback commonCallBack,
    ProgressCallback progressCallBack,
    CancelToken token,
  }) async {
    return await _request(
      url,
      method: PUT,
      options: options,
      params: params,
      callBack: callBack,
      errorCallBack: errorCallBack,
      commonCallBack: commonCallBack,
      progressCallBack: progressCallBack,
      token: token,
    );
  }

  /// Post上传 <br/>
  ///
  /// @param [url] 请求地址 <br/>
  /// @param [formData] 请求form表单数据（可选） <br/>
  /// @param [callBack] 请求结果回调方法（可选） <br/>
  /// @param [errorCallBack] 出错回调（可选） <br/>
  /// @param [commonCallBack] 公共回调方法，成功和失败都会调用（可选） <br/>
  /// @param [progressCallBack] 请求进度回调方法 <br/>
  /// @param [token] 取消请求时使用的CancelToken（可选） <br/>
  Future<bool> postUpload(
    String url, {
    Options options,
    Map<String, dynamic> formData,
    HttpRequestSuccessCallback callBack,
    HttpRequestErrorCallback errorCallBack,
    HttpRequestCommonCallback commonCallBack,
    ProgressCallback progressCallBack,
    CancelToken token,
  }) async {
    return await _request(
      url,
      method: POST,
      options: options,
      formData: formData,
      callBack: callBack,
      errorCallBack: errorCallBack,
      commonCallBack: commonCallBack,
      progressCallBack: progressCallBack,
      token: token,
    );
  }

  /// 统一请求方法 <br/>
  ///
  /// @param [url] 请求地址 <br/>
  /// @param [method] 请求方式：GET、POST、DELETE、PATCH、PUT（可选）<br/>
  /// @param [params] 请求参数（可选） <br/>
  /// @param [formData] 请求form表单数据（可选） <br/>
  /// @param [callBack] 请求结果回调方法（可选） <br/>
  /// @param [errorCallBack] 出错回调（可选） <br/>
  /// @param [commonCallBack] 公共回调方法，成功和失败都会调用（可选） <br/>
  /// @param [progressCallBack] 请求进度回调方法（可选） <br/>
  /// @param [token] 取消请求时使用的CancelToken（可选） <br/>
  Future<bool> _request(
    String url, {
    String method,
    Options options,
    Map<String, dynamic> params,
    Map<String, dynamic> formData,
    HttpRequestSuccessCallback callBack,
    HttpRequestErrorCallback errorCallBack,
    HttpRequestCommonCallback commonCallBack,
    ProgressCallback progressCallBack,
    CancelToken token,
  }) async {
    // restful api 格式化处理
    // 例：将 /user/:userId 转换为 /user/12
    Map<String, dynamic> newParams = HashMap<String, dynamic>();
    params = params ?? {};
    params.forEach((key, value) {
      if (url.indexOf(":$key") != -1) {
        url = url.replaceAll(':$key', value.toString());
      } else {
        newParams.putIfAbsent(key, () => value);
      }
    });
    Response response;
    try {
      switch (method) {
        case GET:
          // 组合GET请求的参数
          if (newParams != null && newParams.isNotEmpty) {
            response = await _client.get(
              url,
              options: options,
              queryParameters: newParams,
              cancelToken: token,
            );
          } else {
            response = await _client.get(
              url,
              options: options,
              cancelToken: token,
            );
          }
          break;
        case POST:
          if (newParams != null && newParams.isNotEmpty) {
            response = await _client.post(
              url,
              data: newParams,
              options: options,
              onSendProgress: progressCallBack,
              cancelToken: token,
            );
          } else if (formData != null && formData.isNotEmpty) {
            response = await _client.post(
              url,
              data: FormData.fromMap(formData),
              options: options,
              onSendProgress: progressCallBack,
              cancelToken: token,
            );
          } else {
            response = await _client.post(
              url,
              options: options,
              cancelToken: token,
            );
          }
          break;
        case DELETE:
          if (newParams != null && newParams.isNotEmpty) {
            response = await _client.delete(
              url,
              options: options,
              queryParameters: newParams,
              cancelToken: token,
            );
          } else {
            response = await _client.delete(
              url,
              options: options,
              cancelToken: token,
            );
          }
          break;
        case PUT:
          if (newParams != null && newParams.isNotEmpty) {
            response = await _client.put(
              url,
              options: options,
              queryParameters: newParams,
              cancelToken: token,
            );
          } else {
            response = await _client.put(
              url,
              options: options,
              cancelToken: token,
            );
          }
          break;
        case PATCH:
          if (newParams != null && newParams.isNotEmpty) {
            response = await _client.patch(
              url,
              options: options,
              queryParameters: newParams,
              cancelToken: token,
            );
          } else {
            response = await _client.patch(
              url,
              options: options,
              cancelToken: token,
            );
          }
          break;
      }
      // 请求回调公共处理方法
      if (commonCallBack != null) commonCallBack();

      // 请求成功的回调
      if (callBack != null) {
        callBack(response.data);
      }
      apiTest(url, params: newParams, result: response.data, code: response.statusCode);
      // 请求成功返回 true
      return true;
    } on DioError catch (e) {
      apiTest(url, params: newParams, result: e.message, code: response?.statusCode);
      if (CancelToken.isCancel(e)) print('网络请求取消：' + e.message);
      // 请求回调公共处理方法s
      if (commonCallBack != null) commonCallBack();
      _handleError(errorCallBack, error: e);
      // 请求失败返回 false
      return false;
    }
  }

  /// 异常处理<br/>
  ///
  /// @param [errorCallback] 错误处理回调方法 <br/>
  /// @param [error] DioError由dio封装的错误信息（可选） <br/>
  /// @param [errorMsg] 出错信息（可选） <br/>
  void _handleError(HttpRequestErrorCallback errorCallback, {DioError error, String errorMsg}) {
    String errorDescription = "";
    String errorOutput = "";
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.other:
          errorDescription = error.message;
          errorOutput = "網絡不順，請檢查網絡後再重新整理";
          break;
        case DioErrorType.cancel:
          errorDescription = "请求被取消";
          errorOutput = "請求取消";
          break;
        case DioErrorType.connectTimeout:
          errorDescription = "连接服务器超时";
          errorOutput = "連接服務器超時";
          break;
        case DioErrorType.sendTimeout:
          errorDescription = "请求服务器超时";
          errorOutput = "請求服務器超時";
          break;
        case DioErrorType.receiveTimeout:
          errorDescription = "服务器响应超时";
          errorOutput = "服務器響應超時";
          break;
        case DioErrorType.response:
          errorDescription = "状态码: " + "${error.response.statusCode}  出错信息: ${error.response.statusMessage}";
          errorOutput = "請求錯誤: ${error.response.statusMessage}";
          break;
      }
    } else if (errorMsg.isNotEmpty) {
      errorDescription = errorMsg;
      errorOutput = "網絡不順，請檢查網絡後再重新整理";
    } else {
      errorDescription = "未知错误";
      errorOutput = "未知錯誤";
    }
    if (errorCallback != null) {
      errorCallback(error, error.response.statusCode);
    } else {
      //ToastManager.show(errorOutput);
    }
  }

  void apiTest(String url, {Map<String, dynamic> params, Object result, int code}) {
    if (!_setting.isRecordRequest) return;
    if (!isDebug || url.startsWith("http://172.16.11.80/")) return;
    HttpRequest.getInstance().post(
      "http://172.16.11.80/laravel/design100/public/api/addHistory",
      params: {
        "requestApi": "${_setting.baseUrl}$url",
        "params": params,
        "result": result,
        "requestState": "$code",
      },
    );
  }
}
