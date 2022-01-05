import 'dart:math';

extension IntOption on int {
  /*
  * 加千分号
  * */
  String get formatNum {
    if (this >= 1000) {
      String value = "$this";
      String sub = "";
      int size = value.length;
      for (var i = 0; i < size; ++i) {
        var bean = value[i];
        sub += bean;
        if ((size - i - 1) % 3 == 0 && i != size - 1) {
          sub += ",";
        }
      }
      return sub;
    } else {
      return "$this";
    }
  }


  /*
  * 生产当前数以内的随机数
  * */
  int get random => Random().nextInt(this);

}
