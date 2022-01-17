abstract class BaseColumn<T> {

  T? content;

  final String type;
  final bool canNull;
  final Object? defaultValue;
  final bool primaryKey;
  final bool autoIncrement;

  BaseColumn({
    this.type = "",
    this.canNull = true,
    this.primaryKey = false,
    this.autoIncrement = false,
    this.defaultValue,
  });


  Map<String, Object> get map => {
    "type": "$type",
    "canNull": "$canNull",
    "primaryKey": "$primaryKey",
    "autoIncrement": "$autoIncrement",
    "defaultValue": "$defaultValue",
  };
}

/// set 集合
class STSet extends BaseColumn<List<int>> {
  /// 枚举
  List<String>? setList = [];

  STSet({
    this.setList,
    bool canNull = true,
    String? defaultValue,
    bool primaryKey = false,
    bool autoIncrement = false,
    String comment = "",
  }) : super(
    type: "set",
    canNull: canNull,
    defaultValue: defaultValue,
    primaryKey: primaryKey,
    autoIncrement: autoIncrement,
  );
}

/// enum 枚举字符串
class STEnum extends BaseColumn<int> {
  /// 枚举
  List<String>? enumList = [];

  STEnum({
    this.enumList,
    bool canNull = true,
    String? defaultValue,
    bool primaryKey = false,
    bool autoIncrement = false,
    String comment = "",
  }) : super(
    type: "enum",
    canNull: canNull,
    defaultValue: defaultValue,
    primaryKey: primaryKey,
    autoIncrement: autoIncrement,
  );
}

/// text 文本字符串
class STText extends BaseColumn<String> {

  STText({
    bool canNull = true,
    String? defaultValue,
    bool primaryKey = false,
    bool autoIncrement = false,
    String comment = "",
  }) : super(
    type: "text",
    canNull: canNull,
    defaultValue: defaultValue,
    primaryKey: primaryKey,
    autoIncrement: autoIncrement,
  );
}


class STDatetime extends BaseColumn<String> {
  STDatetime({
    bool canNull = true,
    Object? defaultValue,
    bool primaryKey = false,
    bool autoIncrement = false,
  }) : super(
    type: "datetime",
    canNull: canNull,
    defaultValue: defaultValue,
    primaryKey: primaryKey,
    autoIncrement: autoIncrement,
  );
}


class STTimestamp extends BaseColumn<int> {

  STTimestamp({
    bool canNull = true,
    Object? defaultValue,
    bool primaryKey = false,
    bool autoIncrement = false,
    String comment = "",
  }) : super(
    type: "timestamp",
    canNull: canNull,
    defaultValue: defaultValue,
    primaryKey: primaryKey,
    autoIncrement: autoIncrement,
  );
}


class STInt extends BaseColumn<int> {

  STInt({
    bool canNull = true,
    Object? defaultValue,
    bool primaryKey = false,
    bool autoIncrement = false,
    String comment = "",
  }) : super(
    type: "integer",
    canNull: canNull,
    defaultValue: defaultValue,
    primaryKey: primaryKey,
    autoIncrement: autoIncrement,
  );
}

class STDouble extends BaseColumn<double> {
  STDouble({
    bool canNull = true,
    Object? defaultValue,
    bool primaryKey = false,
    bool autoIncrement = false,
    String comment = "",
  }) : super(
    type: "double",
    canNull: canNull,
    defaultValue: defaultValue,
    primaryKey: primaryKey,
    autoIncrement: autoIncrement,
  );
}


class STBool extends BaseColumn<bool> {

  STBool({
    bool canNull = true,
    Object? defaultValue,
    bool primaryKey = false,
    bool autoIncrement = false,
    String comment = "",
  }) : super(
    type: "double",
    canNull: canNull,
    defaultValue: defaultValue,
    primaryKey: primaryKey,
    autoIncrement: autoIncrement,
  );
}
