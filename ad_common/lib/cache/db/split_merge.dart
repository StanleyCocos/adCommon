import 'column.dart';

class ColumnSplitMerge {
  static String combine(BaseColumn column, {String key = ""}) {
    switch (column.type) {
      case "text":
        return "$key ${_combineText(column)}";
      case "enum":
        return "$key ${_combineEnum(column)}";
      case "set":
        return "$key ${_combineSet(column)}";
      case "integer":
        return "$key ${_combineInt(column)}";
      case "double":
        return "$key ${_combineDouble(column)}";
      case "datetime":
        return "$key ${_combineDatetime(column)}";
      case "timestamp":
        return "$key ${_combineTimestamp(column)}";
    }
    return "";
  }

  static String _combineText(STText obj) {
    return "text ${_combineColumn(obj)}";
  }

  static String _combineEnum(STEnum obj) {
    return "text ${_combineColumn(obj)}";
  }

  static String _combineSet(STSet obj) {
    return "text ${_combineColumn(obj)}";
  }

  static String _combineInt(STInt obj) {
    return "integer ${_combineColumn(obj)}";
  }

  static String _combineDouble(STDouble obj) {
    return "real ${_combineColumn(obj)}";
  }

  static String _combineDatetime(STDatetime obj) {
    return "text ${_combineColumn(obj)}";
  }

  static String _combineTimestamp(STTimestamp obj) {
    return "timestamp ${_combineColumn(obj)}";
  }

  static String _combineColumn(BaseColumn obj){
    var value = obj.canNull ? "null" : "not null";
    value += value.length > 0 ? " " : "";
    value += obj.primaryKey ? " primary key" : "";
    value += value.length > 0 ? " " : "";
    value += obj.autoIncrement ? "autoincrement" : "";
    value += value.length > 0 ? " " : "";
    value += obj.defaultValue == null ? '' : "default '${obj.defaultValue}'";
    return value;
  }

  static String _toString(List<String> list){
    if(list == null || list.length <= 0) return "";
    var values = "";
    list.forEach((element) {
      values += values.length > 0 ? ",'$element'" : "'$element'";
    });
    return values;
  }
}
