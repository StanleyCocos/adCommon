import 'package:dio/dio.dart';
import 'package:ad_common/ad_common.dart';

void main() {
  HttpRequest.getInstance().startAndSetRequestParams(HttpRequestSetting(logPrintInterceptor: LogPrintInterceptor(), interceptorsWrapper: InterceptorsWrapper()));

  // List<int> dd = [1, 2, 3, 4, 5, 6];
  // print(dd.random);
  // print(dd.item(2));

  Map<String, String> map = {"key1": "11", "key2": "22"};

  map.set(key: "key2");
  print(map);

}
