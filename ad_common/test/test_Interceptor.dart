import 'package:dio/dio.dart';

///网络请求拦截器
class NetworkInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers = getHeaders();
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    var data = response.data;
    if (data is Map) {
      int? code = data['code'];
      print('NetworkInterceptor onResponse=$code ');
    }
    return handler.next(response);
  }

  ///获取头部数据
  Map<String, String> getHeaders() {
    Map<String, String> headers = Map();
    headers['client'] = 'android';
    headers['test'] = '123';
    headers["Accept"] = "application/json";
    return headers;
  }
}
