import 'dart:math';

extension ListOption<E> on List<E>? {
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
  E? stItem(int index) {
    if (isEmptyOrNull) return null;
    if (this!.length <= index || index < 0) return null;
    return this![index];
  }

  /*
  * 删除指定元素
  * */
  void stRemove(int index){
    if (isEmptyOrNull) return;
    if (this!.length <= index || index < 0) return;
    this!.removeAt(index);
  }


  /*
  * 插入指定元素
  * */
  bool stInsert(int index, E? element){
    if(element == null) return false;
    if (isEmptyOrNull) return false;
    if (this!.length <= index || index < 0) return false;
    this!.insert(index, element);
    return true;
  }


  /*
  * 插入指定元素到开始
  * */
  void stInsertStart(E? element){
    if(element == null) return;
    if (isNull) return;
    this!.insert(0, element);
  }

  /*
  * 插入指定元素到结尾
  * */
  void stInsertEnd(E? element){
    if(element == null) return;
    if (isNull) return;
    this!.insert(this!.length, element);
  }

}
