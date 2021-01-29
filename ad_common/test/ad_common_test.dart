import 'package:flutter_test/flutter_test.dart';

import 'package:ad_common/ad_common.dart';

void main() {
  test('dateTime测试', () {
    var e = DateTime.now();
    String value = e.string(format: 'yyyy-MM-dd HH:mm:ss', addZone: true);
    print('test value=$value');

    String timeValue = DateOption.numToStringTimeByDayHourMinute(259200);
    print('test timeValue=$timeValue');
  });
}
