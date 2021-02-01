import 'package:flutter_test/flutter_test.dart';

import 'package:ad_common/ad_common.dart';

void main() {
  test('千分号测试', () {
    // String temp = '12345.934';
    double temp = 1234567890.34;
    String value = temp.formatNum;
    print('test value=$value');
  });

  test('校验测试', () {
    String temp = '校验测试a';

    bool value = RegexManager.isSpecialChar(temp);
    print('test value=$value');
  });
}
