import 'package:ad_common/ad_common.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test('isEmptyOrNull', () {
    String value = '';
    List temp ;
    print('test value isEmpty=${value.isEmptyOrNull}');
    print('test temp isEmpty=${temp.isEmptyOrNull}');
    print('test temp isEmpty=${temp?.isEmptyOrNull}');
  });
}
