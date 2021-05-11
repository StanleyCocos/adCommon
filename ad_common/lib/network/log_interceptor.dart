import 'dart:convert';
import 'package:ad_common/ad_common.dart';
import 'package:ad_common/network/options_extra.dart';
import 'package:dio/dio.dart';

/// [LogPrintInterceptor] is used to print logs during network requests.
/// It's better to add [LogPrintInterceptor] to the tail of the interceptor queue,
/// otherwise the changes made in the interceptor behind A will not be printed out.
/// This is because the execution of interceptors is in the order of addition.
class LogPrintInterceptor extends Interceptor {
  LogPrintInterceptor({
    this.request = true,
    this.requestHeader = true,
    this.requestBody = false,
    this.responseHeader = false,
    this.responseBody = true,
    this.error = true,
    this.logPrint = print,
    this.showLog = isDebug,
  });

  /// Whether to print log [Options]
  bool showLog;

  /// Print request [Options]
  bool request;

  /// Print request header [Options.headers]
  bool requestHeader;

  /// Print request data [Options.data]
  bool requestBody;

  /// Print [Response.data]
  bool responseBody;

  /// Print [Response.headers]
  bool responseHeader;

  /// Print error message
  bool error;

  /// Log printer; defaults print log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file, for example:
  ///```dart
  ///  var file=File("./log.txt");
  ///  var sink=file.openWrite();
  ///  dio.interceptors.add(LogPrintInterceptor(logPrint: sink.writeln));
  ///  ...
  ///  await sink.close();
  ///```
  void Function(Object object) logPrint;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
    if (!showLog) return;
    printV('*************** 请求发起 ***************');
    printKV('请求链接', options.uri);

    //单个请求-是否打印-请求参数
    bool singleRequestShowLog = options.extra[singleRequestShowLogKey] ?? true;
    if (request && singleRequestShowLog) {
      printKV('请求方式', options.method);
      if (options.method == "POST") {
        if (options.data is FormData) {
          StringBuffer sb = StringBuffer();
          sb.write("{");
          (options.data as FormData).fields.forEach((e) {
            sb.write("${e.key}: ${e.value}, ");
          });
          sb.write("}");
          printKV('请求参数', sb.toString());
        } else {
          printKV('请求参数', options.data);
        }
      } else {
        printKV('请求参数', options.queryParameters);
      }
    }

    //单个请求-是否打印-请求头部
    bool singleRequestHeaderShowLog = options.extra[singleRequestHeaderShowLogKey] ?? true;
    if (requestHeader && singleRequestHeaderShowLog) {
      printV("请求头部:");
      options.headers.forEach((key, v) {
        if (key == "Authorization") {
          if (v.toString().length > 800) {
            printKV("$key", "${v.toString().substring(0, 800)}");
            printV("${v.toString().substring(800, v.toString().length)}");
          } else {
            printKV("$key", "$v");
          }
        } else {
          printKV("$key", "$v");
        }
      });
    }

    //单个请求-是否打印-请求参数
    bool singleRequestBodyShowLog = options.extra[singleRequestBodyShowLogKey] ?? true;
    if (requestBody && singleRequestBodyShowLog) {
      printV("请求参数 Body:");
      prettyPrintJson(options.data);
    }
    printV("");
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    if (!showLog) return;

    //单个请求-是否打印-错误信息
    bool singleErrorShowLog = err.requestOptions.extra[singleErrorShowLogKey] ?? true;
    if (error && singleErrorShowLog) {
      printV('*************** 请求出错 ***************:');
      printKV("出错链接", err.requestOptions.uri);
      printKV("出错原因", err);
      if (err.response != null) {
        _printResponse(err.response);
      }
      printV("");
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    if (!showLog) return;
    printV("*************** 请求响应 ***************");
    _printResponse(response);
  }

  void _printResponse(Response response) {
    printKV('响应链接', response.requestOptions?.uri);
    //单个请求-是否打印-响应头
    bool singleResponseHeaderShowLog = response.requestOptions.extra[singleResponseHeaderShowLogKey] ?? true;
    if (responseHeader && singleResponseHeaderShowLog) {
      printKV('响应状态码', response.statusCode);
      if (response.isRedirect == true) {
        printKV('redirect', response.realUri);
      }
      if (response.headers != null) {
        var headers = response.headers.toString()?.replaceAll("\n", "\n ");
        if (headers != null) {
          printKV('响应头部', headers);
        }
      }
    }

    //单个请求-是否打印-响应头
    bool singleResponseBodyShowLog = response.requestOptions.extra[singleResponseBodyShowLogKey] ?? true;
    if (responseBody && singleResponseBodyShowLog) {
      printV("响应内容:");
      prettyPrintJson(response.toString());
    }
    printV("");
  }

  printV(Object v) {
    logPrint('$v');
  }

  printKV(String key, Object v) {
    logPrint('$key: $v');
  }

  JsonDecoder decoder = JsonDecoder();
  JsonEncoder encoder = JsonEncoder.withIndent('  ');

  /// 打印Json格式化数据
  void prettyPrintJson(String input) {
    try {
      var object = decoder.convert(input);
      var prettyString = encoder.convert(object);
      prettyString.split('\n').forEach((element) => print(element));
    } on FormatException catch (_) {
      logPrint(input);
    }
  }
}
