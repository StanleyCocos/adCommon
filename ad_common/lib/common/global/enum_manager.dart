
import 'package:ad_common/common/extension/string_extension.dart';

class EnumManager {

  static String string(String enumStr){
    if (enumStr.isEmptyOrNull) return "";
    var tempArray = enumStr.split(".");
    if(tempArray.length >= 2) {
      return tempArray[0];
    }
    return "";
  }
}