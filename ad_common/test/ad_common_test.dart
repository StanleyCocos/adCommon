import 'package:dio/dio.dart';
import 'package:ad_common/ad_common.dart';

void main() {
  HttpRequest.getInstance().startAndSetRequestParams(HttpRequestSetting(logPrintInterceptor: LogPrintInterceptor(), interceptorsWrapper: InterceptorsWrapper()));
}
