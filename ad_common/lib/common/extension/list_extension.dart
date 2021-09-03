import 'dart:math';

extension ListOption<E> on List? {
  /*
  * 是否为null
  * */
  bool get isNull => this == null;

  /*
  * 是否为null或者空数组
  * */
  bool get isEmptyOrNull {
    if (isNull) return true;
    if (this!.isEmpty) return true;
    return false;
  }

  /*
  * 是否不为null或者空数组
  * */
  bool get isNotEmptyOrNull => !isEmptyOrNull;

  /*
  * 随机获取元素
  * */
  E? get random {
    if (isEmptyOrNull) return null;
    return this![Random().nextInt(this!.length)];
  }

  /*
  * 获取指定元素
  * */
  E? item(int index) {
    if (isEmptyOrNull) return null;
    if (this!.length <= index || index < 0) return null;
    return this![index];
  }
}
