import 'package:dio/dio.dart';

///网络请求-头部拦截器
class HeaderInterceptor extends InterceptorsWrapper {
  /// 添加Header拦截器 <br/>
  addHeaderInterceptors(RequestOptions options) {
    ///todo
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    ///todo
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    ///todo
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    ///todo
    return super.onError(err, handler);
  }
}
