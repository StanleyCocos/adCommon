import 'dart:collection';
import 'dart:io';

import 'package:ad_common/common/extension/log_extension.dart';
import 'package:ad_common/common/extension/string_extension.dart';
import 'package:ad_common/network/options_extra.dart';
import 'package:ad_common/ui/widget/toast_manager.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

import 'http_request_setting.dart';

typedef HttpRequestSuccessCallback = void Function(dynamic data);
typedef HttpRequestErrorCallback = void Function(DioError? error, int? stateCode);
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
  static HttpRequest? _instance;

  /// 请求方式
  static const String GET = "get";
  static const String POST = "post";
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';

  factory HttpRequest() => getInstance();

  static HttpRequest getInstance() {
    if (_instance == null) {
      _instance = HttpRequest._internal();
    }
    return _instance!;
  }

  Dio? _client;

  Dio? get client => _client;

  HttpRequest._internal();

  /// 启动请求工具 并且设置请求参数
  void init(HttpRequestSetting setting) async {
    if (_client == null) {
      BaseOptions options = BaseOptions();
      if (setting.dev.isNotEmptyOrNull)
        options.headers[HttpHeaders.cookieHeader] = "dev=${setting.dev};";
      options.connectTimeout = setting.connectTimeOut * 1000;
      options.receiveTimeout = setting.receiveTimeOut * 1000;
      options.baseUrl = setting.baseUrl;
      options.contentType = setting.contentType;
      _client = Dio(options);
      setting.interceptors?.forEach((interceptor) {
        _client!.interceptors.add(interceptor);
      });
      if (isDebug && !setting.delegateHost.isEmptyOrNull) {
        (_client!.httpClientAdapter as DefaultHttpClientAdapter)
            .onHttpClientCreate = (client) {
          client.findProxy = (url) {
            return "PROXY ${setting.delegateHost}";
          };
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
        };
      }
    }
  }

  /// Get请求 <br/>
  ///
  /// @param [url] 请求地址 <br/>
  /// @param [params] 请求参数（可选） <br/>
  /// @param [extra] 扩展（可选） <br/>
  /// @param [callBack] 请求结果回调方法（可选） <br/>
  /// @param [errorCallBack] 出错回调（可选） <br/>
  /// @param [commonCallBack] 公共回调方法，成功和失败都会调用（可选） <br/>
  /// @param [token] 取消请求时使用的CancelToken（可选） <br/>
  Future<bool> get(
    String url, {
    Options? options,
    Map<String, dynamic>? params,
    OptionsExtra? extra,
    HttpRequestSuccessCallback? callBack,
    HttpRequestErrorCallback? errorCallBack,
    HttpRequestCommonCallback? commonCallBack,
    CancelToken? token,
  }) async {
    return await _request(
      url,
      method: GET,
      options: options,
      params: params,
      extra: extra,
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
  /// @param [extra] 扩展（可选） <br/>
  /// @param [callBack] 请求结果回调方法（可选） <br/>
  /// @param [errorCallBack] 出错回调（可选） <br/>
  /// @param [commonCallBack] 公共回调方法，成功和失败都会调用（可选） <br/>
  /// @param [token] 取消请求时使用的CancelToken（可选） <br/>
  Future<bool> post(
    String url, {
    Options? options,
    Map<String, dynamic>? params,
    Map<String, dynamic>? formData,
    OptionsExtra? extra,
    HttpRequestSuccessCallback? callBack,
    HttpRequestErrorCallback? errorCallBack,
    HttpRequestCommonCallback? commonCallBack,
    CancelToken? token,
  }) async {
    return await _request(
      url,
      method: POST,
      options: options,
      params: params,
      formData: formData,
      extra: extra,
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
  /// @param [extra] 扩展（可选） <br/>
  /// @param [callBack] 请求结果回调方法（可选） <br/>
  /// @param [errorCallBack] 出错回调（可选） <br/>
  /// @param [commonCallBack] 公共回调方法，成功和失败都会调用（可选） <br/>
  /// @param [token] 取消请求时使用的CancelToken（可选） <br/>
  Future<bool> delete(
    String url, {
    Options? options,
    Map<String, dynamic>? params,
    OptionsExtra? extra,
    HttpRequestSuccessCallback? callBack,
    HttpRequestErrorCallback? errorCallBack,
    HttpRequestCommonCallback? commonCallBack,
    CancelToken? token,
  }) async {
    return await _request(
      url,
      method: DELETE,
      options: options,
      params: params,
      extra: extra,
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
  /// @param [extra] 扩展（可选） <br/>
  /// @param [callBack] 请求结果回调方法（可选） <br/>
  /// @param [errorCallBack] 出错回调（可选） <br/>
  /// @param [commonCallBack] 公共回调方法，成功和失败都会调用（可选） <br/>
  /// @param [token] 取消请求时使用的CancelToken（可选） <br/>
  Future<bool> patch(
    String url, {
    Options? options,
    Map<String, dynamic>? params,
    OptionsExtra? extra,
    HttpRequestSuccessCallback? callBack,
    HttpRequestErrorCallback? errorCallBack,
    HttpRequestCommonCallback? commonCallBack,
    CancelToken? token,
  }) async {
    return await _request(
      url,
      method: PATCH,
      options: options,
      params: params,
      extra: extra,
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
  /// @param [extra] 扩展（可选） <br/>
  /// @param [callBack] 请求结果回调方法（可选） <br/>
  /// @param [errorCallBack] 出错回调（可选） <br/>
  /// @param [commonCallBack] 公共回调方法，成功和失败都会调用（可选） <br/>
  /// @param [progressCallBack] 请求进度回调方法 <br/>
  /// @param [onReceiveProgress] 接收进度回调方法 <br/>
  /// @param [token] 取消请求时使用的CancelToken（可选） <br/>
  Future<bool> put(
    String url, {
    Options? options,
    Map<String, dynamic>? params,
    OptionsExtra? extra,
    HttpRequestSuccessCallback? callBack,
    HttpRequestErrorCallback? errorCallBack,
    HttpRequestCommonCallback? commonCallBack,
    ProgressCallback? progressCallBack,
    CancelToken? token,
  }) async {
    return await _request(
      url,
      method: PUT,
      options: options,
      params: params,
      extra: extra,
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
  /// @param [extra] 扩展（可选） <br/>
  /// @param [callBack] 请求结果回调方法（可选） <br/>
  /// @param [errorCallBack] 出错回调（可选） <br/>
  /// @param [commonCallBack] 公共回调方法，成功和失败都会调用（可选） <br/>
  /// @param [progressCallBack] 请求进度回调方法 <br/>
  /// @param [token] 取消请求时使用的CancelToken（可选） <br/>
  Future<bool> postUpload(
    String url, {
    Options? options,
    Map<String, dynamic>? formData,
    OptionsExtra? extra,
    HttpRequestSuccessCallback? callBack,
    HttpRequestErrorCallback? errorCallBack,
    HttpRequestCommonCallback? commonCallBack,
    ProgressCallback? progressCallBack,
    CancelToken? token,
  }) async {
    return await _request(
      url,
      method: POST,
      options: options,
      formData: formData,
      extra: extra,
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
  /// @param [extra] 扩展（可选） <br/>
  /// @param [callBack] 请求结果回调方法（可选） <br/>
  /// @param [errorCallBack] 出错回调（可选） <br/>
  /// @param [commonCallBack] 公共回调方法，成功和失败都会调用（可选） <br/>
  /// @param [progressCallBack] 请求进度回调方法（可选） <br/>
  /// @param [token] 取消请求时使用的CancelToken（可选） <br/>
  Future<bool> _request(
    String url, {
    String? method,
    Options? options,
    Map<String, dynamic>? params,
    Map<String, dynamic>? formData,
    OptionsExtra? extra,
    HttpRequestSuccessCallback? callBack,
    HttpRequestErrorCallback? errorCallBack,
    HttpRequestCommonCallback? commonCallBack,
    ProgressCallback? progressCallBack,
    CancelToken? token,
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

    //请求扩展
    if (options == null) options = Options();
    if (extra == null) extra = OptionsExtra();
    options.extra = {
      singleRequestShowLogKey: extra.singleRequestShowLog,
      singleRequestHeaderShowLogKey: extra.singleRequestHeaderShowLog,
      singleRequestBodyShowLogKey: extra.singleRequestBodyShowLog,
      singleResponseHeaderShowLogKey: extra.singleResponseHeaderShowLog,
      singleResponseBodyShowLogKey: extra.singleResponseBodyShowLog,
      singleErrorShowLogKey: extra.singleErrorShowLog,
      singleShowErrorToastKey: extra.singleErrorToastKey,
    };

    late Response response;
    try {
      switch (method) {
        case GET:
          // 组合GET请求的参数
          if (newParams.isNotEmpty) {
            response = await _client!.get(
              url,
              options: options,
              queryParameters: newParams,
              cancelToken: token,
            );
          } else {
            response = await _client!.get(
              url,
              options: options,
              cancelToken: token,
            );
          }
          break;
        case POST:
          if (newParams.isNotEmpty) {
            response = await _client!.post(
              url,
              data: newParams,
              options: options,
              onSendProgress: progressCallBack,
              cancelToken: token,
            );
          } else if (formData != null && formData.isNotEmpty) {
            response = await _client!.post(
              url,
              data: FormData.fromMap(formData),
              options: options,
              onSendProgress: progressCallBack,
              cancelToken: token,
            );
          } else {
            response = await _client!.post(
              url,
              options: options,
              cancelToken: token,
            );
          }
          break;
        case DELETE:
          if (newParams.isNotEmpty) {
            response = await _client!.delete(
              url,
              options: options,
              queryParameters: newParams,
              cancelToken: token,
            );
          } else {
            response = await _client!.delete(
              url,
              options: options,
              cancelToken: token,
            );
          }
          break;
        case PUT:
          if (newParams.isNotEmpty) {
            response = await _client!.put(
              url,
              options: options,
              queryParameters: newParams,
              cancelToken: token,
            );
          } else {
            response = await _client!.put(
              url,
              options: options,
              cancelToken: token,
            );
          }
          break;
        case PATCH:
          if (newParams.isNotEmpty) {
            response = await _client!.patch(
              url,
              options: options,
              queryParameters: newParams,
              cancelToken: token,
            );
          } else {
            response = await _client!.patch(
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
      Map<String, dynamic> tempHeader = {};
      if (_client?.options.headers != null &&
          _client!.options.headers.length > 0) {
        tempHeader.addAll(_client!.options.headers);
      }
      if (options.headers != null && options.headers!.length > 0) {
        tempHeader.addAll(options.headers!);
      }
      // 请求成功返回 true
      return true;
    } on DioError catch (e) {
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
  void _handleError(HttpRequestErrorCallback? errorCallback,
      {DioError? error, String? errorMsg}) {
    String errorOutput = "";
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.other:
          errorOutput = "網絡不順，請檢查網絡後再重新整理";
          break;
        case DioErrorType.cancel:
          errorOutput = "請求取消";
          break;
        case DioErrorType.connectTimeout:
          errorOutput = "連接服務器超時";
          break;
        case DioErrorType.sendTimeout:
          errorOutput = "請求服務器超時";
          break;
        case DioErrorType.receiveTimeout:
          errorOutput = "服務器響應超時";
          break;
        case DioErrorType.response:
          errorOutput = "請求錯誤: ${error.response!.statusMessage}";
          break;
      }
    } else if (errorMsg!.isNotEmpty) {
      errorOutput = "網絡不順，請檢查網絡後再重新整理";
    } else {
      errorOutput = "未知錯誤";
    }

    // 是否显示错误提示
    bool singleShowErrorToast =
        error?.requestOptions.extra[singleShowErrorToastKey] ?? false;
    if (errorCallback != null) {
      if (error?.response?.statusCode == null) {
        errorCallback(error, 0);
      } else {
        errorCallback(error, error?.response?.statusCode);
      }
    } else if (singleShowErrorToast) {
      ToastManager.show(errorOutput);
    }
  }
}
