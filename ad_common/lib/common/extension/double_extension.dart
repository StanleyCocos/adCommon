extension doubleOption on double {



  String string(int decimal) {
    return "$this";
  }
  /*
  * 加千分号
  * */
  String formatNumByInt(int num) {
    if (num >= 1000) {
      String value = "$num";
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
      return "$num";
    }
  }

  /*
  * 加千分号
  * */
  String get formatNum {
    List<String> numSub = '$this'.split(".");
    try {
      int upValue = int.parse(numSub.first);
      String value = formatNumByInt(upValue);
      for (var i = 1; i < numSub.length; ++i) {
        var bean = numSub[i];
        if (i == 1) {
          value += ".";
        }
        value += bean;
      }
      return value;
    } catch (e) {
      Future.error(e);
    }
    return '$this';
  }
}
