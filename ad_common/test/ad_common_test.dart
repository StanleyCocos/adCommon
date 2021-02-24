import 'package:dio/dio.dart';
import 'package:ad_common/ad_common.dart';

void main() {
  HttpRequest.getInstance().startAndSetRequestParams(HttpRequestSetting(logPrintInterceptor: LogPrintInterceptor(), interceptorsWrapper: InterceptorsWrapper()));

  List<int> dd = [1, 2, 3, 4, 5, 6];
  print(dd.random);

}
