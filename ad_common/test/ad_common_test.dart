import 'package:ad_common/ad_common.dart';
import 'package:ad_common/network/http_request.dart';
import 'package:ad_common/network/test_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_Interceptor.dart';

void main() {
  test('isEmptyOrNull', () {
    String value = '';
    List temp;
    print('test value isEmpty=${value.isEmptyOrNull}');
    print('test temp isEmpty=${temp.isEmptyOrNull}');
    print('test temp isEmpty=${temp?.isEmptyOrNull}');
  });

  test('dio-4.0.0', () async {
    HttpRequest().init(HttpRequestSetting(
      connectTimeOut: 30,
      receiveTimeOut: 30,
      interceptors: [
        NetworkInterceptor(),
        ApiTestInterceptor(),
        LogPrintInterceptor(
          responseBody: true,
          showLog: true,
          requestHeader: true,
        ),
      ],
    ));

    String url = 'https://m.debug.8591.com.hk/node/mall/detail';
    var param = {'id': 3982052};
    HttpRequest.getInstance().get(
      url,
      params: param,
      callBack: (data) {
        print('get callBack');
      },
      commonCallBack: () {
        print('get commonCallBack');
      },
      errorCallBack: (err, code) {
        print('get errorCallBack');
      },
    );

    // var dio = Dio();
    // final response = await dio.get('https://google.com');
    // print(response.data);
    print('test over');
  });
}
