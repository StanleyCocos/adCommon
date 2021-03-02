import 'package:sqflite/sqflite.dart';

import 'column.dart';
import 'db_manager.dart';
import 'split_merge.dart';

abstract class BaseTableModel {
  /*
  * 表相应的的列字段属性
  * */
  Map<String, BaseColumn> get map;

  /*
  * 需要提供实现类的实例
  * */
  BaseTableModel copy();

  /*
  * 是否正常获取到结果(未测试)
  * */
  bool result = false;

  /*
  * 默认主键
  * */
  STInt id = STInt(primaryKey: true, autoIncrement: true);

  /*
  * 执行相应的sql
  * */
  static Future<void> execute(String sql) async {
    Database db = await DBManager.getDatabase();
    return await db?.execute(sql);
  }

  /*
  * 清空表
  * */
  Future<int> clear(String table) async {
    Database db = await DBManager.getDatabase();
    return await db?.rawDelete("DELETE FROM table $runtimeType");
  }

  /*
  * 创建表
  * */
  Future create() async {
    var createSql = "create table if not exists $runtimeType($column);";
    Database db = await DBManager.getDatabase();
    return await db?.execute(createSql);
  }

  /*
  *  插入数据
  * */
  Future<int> save() async {
    await create();
    Database db = await DBManager.getDatabase();
    return await db?.insert("$runtimeType", contentMap);
  }

  /*
  *  批量插入数据
  * */
  Future<void> saveAll<T extends BaseTableModel>(List<T> list) async {
    Database db = await DBManager.getDatabase();
    await db.transaction((txn) async {
      list.forEach((element) async {
        await txn.insert("$runtimeType", element.contentMap);
      });
    });
  }

  /*
  * 更新数据
  * */
  Future<int> update({String where}) async {
    Database db = await DBManager.getDatabase();
    return await db?.update("$runtimeType", contentMap,
        where: where == null ? "id = ${id.content}" : where);
  }

  /*
  * 删除数据
  * */
  Future<int> delete({String where}) async {
    Database db = await DBManager.getDatabase();
    return await db?.delete("$runtimeType",
        where: where == null ? "id = ${id.content}" : where);
  }

  /*
  * 清空表数据
  * */
  Future<int> deleteAll() async {
    Database db = await DBManager.getDatabase();
    return await db.rawDelete("DELETE FROM $runtimeType");
  }

  /*
  * 判断当前查询数据是否存在
  * */
  Future<bool> contain({String where = ""}) async {
    Database db = await DBManager.getDatabase();
    List<String> columns = List.from(map.keys);
    List<Map> data = await db.query(
      "$runtimeType",
      where: where.isNotEmpty ? where : "id=(select last_insert_id())",
      columns: columns,
    );
    return data.isNotEmpty;
  }

  /*
  * 获取单挑记录
  * */
  Future<BaseTableModel> one({String where = ""}) async {
    Database db = await DBManager.getDatabase();
    List<String> columns = List.from(map.keys);
    List<Map> data = await db.query(
      "$runtimeType",
      where: where.isNotEmpty ? where : "id=(select last_insert_id())",
      columns: columns,
    );
    if (data.length <= 0) return null;
    result = true;
    setRowContent(rowData: data.first);
    return this;
  }

  /*
  * 获取所有记录
  * */
  Future<List<T>> all<T extends BaseTableModel>() async {
    var db = await DBManager.getDatabase();
    List<Map> maps = await db.query(
      "$runtimeType",
    );
    print(maps);
    if (maps == null || maps.length == 0) return [];

    List<T> list = [];
    maps.forEach((element) {
      var obj = this.copy();
      obj.setRowContent(rowData: element);
      list.add(obj);
    });
    return list;
  }

  /*
  * 获取模型的键值对
  * */
  Map<String, Object> get json {
    Map<String, Object> json = {};
    map.forEach((key, value) {
      json[key] = value.content;
    });
    return json;
  }
}

/*
* 数据处理
* */
extension DataOption on BaseTableModel {
  /*
  * 获取列键值对
  * */
  Map<String, Object> get contentMap {
    if (map == null || map.length <= 0) return {};
    Map<String, Object> contents = {};
    map.forEach((k, v) {
      if (v.type == "enum") {
        contents[k] = getEnumContent(v);
      } else if (v.type == "set") {
        contents[k] = getSetContent(v);
      } else {
        contents[k] = v.content;
      }
    });
    return contents;
  }

  /*
  * 转换枚举列数据
  * */
  String getEnumContent(STEnum obj) {
    if (obj.enumList.length <= 0 || obj.content == null) return "";
    if (obj.content >= 0 && obj.content < obj.enumList.length) {
      return obj.enumList[obj.content];
    }
    return "";
  }

  /*
  * 转换集合列数据
  * */
  String getSetContent(STSet obj) {
    if (obj.setList.length <= 0 ||
        obj.content == null ||
        obj.content.length <= 0) return "";
    var value = "";
    obj.content.forEach((element) {
      if (element >= 0 && element < obj.setList.length) {
        value += value.length > 0
            ? ",${obj.setList[element]}"
            : "${obj.setList[element]}";
      }
    });
    return value;
  }

  /*
  * 获取所有列的值
  * */
  String get values {
    if (map == null || map.length <= 0) return "";
    var value = "";
    map.forEach((k, v) {
      value += value.length > 0 ? ",$v" : "$v";
    });
    return value;
  }

  /*
  * 获取所有列的名称
  * */
  String get keys {
    if (map == null || map.length <= 0) return "";
    var key = "";
    map.forEach((k, v) {
      key += key.length > 0 ? ",$k" : "$k";
    });
    return key;
  }

  /*
  * 获取整体列的所有声明和属性
  * */
  String get column {
    if (map == null || map.length <= 0) return "";
    var columns = "";
    map.forEach((k, v) {
      var temp = columns.length > 0 ? "," : "";
      columns += "$temp${ColumnSplitMerge.combine(v, key: k)}";
    });

    return columns;
  }

  /*
  * 映射模型相应的值
  * */
  void setRowContent({Map<String, Object> rowData}) {
    if (rowData == null || rowData.length <= 0) return;
    var temp = map;
    temp["id"].content = 2;
    rowData.forEach((key, value) {
      if (temp[key].type == "set") {
        temp[key].content = setSetRowContent(temp[key], value);
      } else if (temp[key].type == "enum") {
        temp[key].content = setEnumRowContent(temp[key], value);
      } else {
        temp[key].content = value;
      }
    });
    this.result = true;
  }

  /*
  * 映射转换枚举的值
  * */
  int setEnumRowContent(STEnum obj, String value) {
    for (int index = 0; index < obj.enumList.length; index++) {
      var element = obj.enumList[index];
      if (value == element) {
        return index;
      }
    }
    return null;
  }

  /*
  * 映射集合枚举的值
  * */
  List<int> setSetRowContent(STSet obj, String value) {
    List<String> list = value.split(",");
    List<int> indexList = [];
    for (int index = 0; index < obj.setList.length; index++) {
      var element = obj.setList[index];
      if (list.contains(element)) {
        indexList.add(index);
      }
    }
    return indexList;
  }
}
