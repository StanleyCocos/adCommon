import 'dart:async';

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
    Database? db = await DBManager.getDatabase();
    return await db?.execute(sql);
  }

  /*
  * 创建表
  * */
  Future create() async {
    try {
      var createSql = "create table if not exists $runtimeType($column);";
      Database? db = await DBManager.getDatabase();
      return await db?.execute(createSql);
    } catch (e) {}
  }

  /*
  *  插入数据
  * */
  Future<int> save() async {
    try {
      await create();
      Database? db = await DBManager.getDatabase();
      return (await db?.insert("$runtimeType", contentMap))!;
    } catch (e) {
      return 0;
    }
  }

  /*
  *  批量插入数据
  * */
  Future<int> saveBatch<T extends BaseTableModel>(List<T> list) async {
    try {
      await create();
      Database db = await (DBManager.getDatabase() as FutureOr<Database>);
      var count = 0;
      await db.transaction((txn) async {
        list.forEach((element) async {
          var state = await txn.insert("$runtimeType", element.contentMap);
          if (state > 0) count++;
        });
      });
      return count;
    } catch (e) {
      return 0;
    }
  }

  /*
  * 更新数据
  * */
  Future<int> update({String? where}) async {
    try {
      Database? db = await DBManager.getDatabase();
      return (await db?.update("$runtimeType", contentMap,
          where: where == null ? "id = ${id.content}" : where))!;
    } catch (e) {
      return 0;
    }
  }

  /*
  * 删除数据
  * */
  Future<int> delete({String? where}) async {
    try {
      Database? db = await DBManager.getDatabase();
      return (await db?.delete("$runtimeType",
          where: where == null ? "id = ${id.content}" : where))!;
    } catch (e) {
      return 0;
    }
  }

  /*
  * 清空表
  * */
  Future<int> clear() async {
    try {
      Database db = await (DBManager.getDatabase() as FutureOr<Database>);
      return await db.rawDelete("DELETE FROM $runtimeType");
    } catch (e) {
      return 0;
    }
  }

  /*
  * 判断当前查询数据是否存在
  * */
  Future<bool> contain({String where = ""}) async {
    try {
      Database db = await (DBManager.getDatabase() as FutureOr<Database>);
      List<String> columns = List.from(map.keys);
      List<Map> data = await db.query(
        "$runtimeType",
        where: where.isNotEmpty ? where : "id=(select last_insert_rowid())",
        columns: columns,
      );
      return data.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /*
  * 获取单挑记录
  * */
  Future<BaseTableModel?> one({String where = ""}) async {
    try {
      Database db = await (DBManager.getDatabase() as FutureOr<Database>);
      List<String> columns = List.from(map.keys);
      List<Map> data = await db.query(
        "$runtimeType",
        where: where.isNotEmpty ? where : "id=(select last_insert_rowid())",
        columns: columns,
      );
      if (data.length <= 0) return null;
      setRowContent(rowData: data.first as Map<String, Object?>?);
      return this;
    } catch (e) {
      return null;
    }
  }

  /*
  * 获取所有记录
  * */
  Future<List<T>> all<T extends BaseTableModel>() async {
    try {
      var db = await (DBManager.getDatabase() as FutureOr<Database>);
      List<Map> maps = await db.query(
        "$runtimeType",
      );
      if (maps.length == 0) return [];
      List<T> list = [];
      maps.forEach((element) {
        var obj = this.copy();
        obj.setRowContent(rowData: element as Map<String, Object?>?);
        list.add(obj as T);
      });
      return list;
    } catch (e) {
      return [];
    }
  }

  /*
  * 获取模型的键值对
  * */
  Map<String, Object?> get json {
    Map<String, Object?> json = {};
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
  Map<String, Object?> get contentMap {
    if (map.length <= 0) return {};
    Map<String, Object?> contents = {};
    map.forEach((k, v) {
      if (v.type == "enum") {
        contents[k] = getEnumContent(v as STEnum);
      } else if (v.type == "set") {
        contents[k] = getSetContent(v as STSet);
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
    if (obj.enumList!.length <= 0 || obj.content == null) return "";
    if (obj.content! >= 0 && obj.content! < obj.enumList!.length) {
      return obj.enumList![obj.content!];
    }
    return "";
  }

  /*
  * 转换集合列数据
  * */
  String getSetContent(STSet obj) {
    if (obj.setList!.length <= 0 ||
        obj.content == null ||
        obj.content!.length <= 0) return "";
    var value = "";
    obj.content!.forEach((element) {
      if (element >= 0 && element < obj.setList!.length) {
        value += value.length > 0
            ? ",${obj.setList![element]}"
            : "${obj.setList![element]}";
      }
    });
    return value;
  }

  /*
  * 获取所有列的值
  * */
  String get values {
    if (map.length <= 0) return "";
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
    if (map.length <= 0) return "";
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
    if (map.length <= 0) return "";
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
  void setRowContent({Map<String, Object?>? rowData}) {
    if (rowData == null || rowData.length <= 0) return;
    var temp = map;
    rowData.forEach((key, value) {
      if (temp[key]!.type == "set") {
        temp[key]!.content =
            setSetRowContent(temp[key] as STSet, value as String);
      } else if (temp[key]!.type == "enum") {
        temp[key]!.content =
            setEnumRowContent(temp[key] as STEnum, value as String?);
      } else {
        temp[key]!.content = value;
      }
    });
    this.result = true;
  }

  /*
  * 映射转换枚举的值
  * */
  int? setEnumRowContent(STEnum obj, String? value) {
    for (int index = 0; index < obj.enumList!.length; index++) {
      var element = obj.enumList![index];
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
    for (int index = 0; index < obj.setList!.length; index++) {
      var element = obj.setList![index];
      if (list.contains(element)) {
        indexList.add(index);
      }
    }
    return indexList;
  }
}
