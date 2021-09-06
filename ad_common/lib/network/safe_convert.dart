/// 类型安全转换工具
class SafeManager {
  /// 将不确定的类型转换为int类型 <br>
  ///
  /// @param value ：待转换的类型 <br>
  /// @return 转换后的int类型 <br>
  static int parseInt(Map<String, dynamic>? data, String key,
      {int defaultValue = 0}) {
    try {
      Object? value = data?[key];
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is bool) return value ? 1 : 0;
      if (value is String) {
        return int.tryParse(value) ?? double.tryParse(value)!.toInt();
      }
      return defaultValue;
    } catch (error) {
      return defaultValue;
    }
  }

  /// 将不确定的类型转换为double类型 <br>
  ///
  /// @param value ：待转换的类型 <br>
  /// @return 转换后的double类型 <br>
  static double parseDouble(Map<String, dynamic>? data, String key,
      {double defaultValue = 0.0}) {
    try {
      Object? value = data?[key];
      if (value == null) return defaultValue;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is bool) return value ? 1.0 : 0.0;
      if (value is String) {
        var temp = double.tryParse(value);
        if (temp == null) return defaultValue;
        return temp;
      }
      return defaultValue;
    } catch (error) {
      return defaultValue;
    }
  }

  /// 将不确定的类型转换为String类型 <br>
  ///
  /// @param value ：待转换的类型 <br>
  /// @return 转换后的String类型 <br>
  static String parseString(Map<String, dynamic>? data, String key,
      {String defaultValue = ""}) {
    try {
      Object? value = data?[key];
      if (value == null) return defaultValue;
      if (value is String) return value;
      if (value is int) return value.toString();
      if (value is bool) return value ? "true" : "false";
      if (value is double) return value.toString();
      return defaultValue;
    } catch (error) {
      return defaultValue;
    }
  }

  /// 将不确定的类型转换为bool类型 <br>
  ///
  /// @param value ：待转换的类型 <br>
  /// @return 转换后的bool类型 <br>
  static bool parseBoolean(Map<String, dynamic>? data, String key,
      {bool defaultValue = false}) {
    try {
      Object? value = data?[key];
      if (value == null) return defaultValue;
      if (value is bool) return value;
      if (value is int) {
        if (value == 1) return true;
        if (value == 0) return false;
        return false;
      }
      if (value is double) {
        if (value == 1.0) return true;
        if (value == 0.0) return false;
        return false;
      }
      if (value is String) {
        if (value.toLowerCase() == 'true') return true;
        if (value.toLowerCase() == '1') return true;
        if (value.toLowerCase() == 'false') return false;
        if (value.toLowerCase() == '0') return false;
        return defaultValue;
      }
      return defaultValue;
    } catch (error) {
      return defaultValue;
    }
  }

  /// 将不确定的类型转换为List类型 <br>
  ///
  /// @param value ：待转换的类型 <br>
  /// @return 转换后的List类型 <br>
  static List parseList(Map<String, dynamic>? data, String key) {
    try {
      Object? value = data?[key];
      if (value == null) return [];
      if (value is List) return value;
      return [];
    } catch (error) {
      return [];
    }
  }

  /// 将不确定的类型转换为List<String>类型 <br>
  ///
  /// @param value ：待转换的类型 <br>
  /// @return 转换后的List<String>类型 <br>
  static List<String> parseStrList(Map<String, dynamic>? data, String key) {
    try {
      Object? value = data?[key];
      if (value == null) return [];
      if (value is List) {
        List<String> listArray = [];
        for (var obj in value) {
          if (obj != null && obj != "null") {
            if (obj is String) {
              listArray.add(obj);
            }
          }
        }
        return listArray;
      }
      return [];
    } catch (error) {
      return [];
    }
  }

  /// 将不确定的类型转换为Object类型 <br>
  ///
  /// @param value ：待转换的类型 <br>
  /// @return 转换后的Object类型 <br>
  static Map<String, dynamic>? parseObject(
      Map<String, dynamic>? data, String key) {
    try {
      var value = Map<String, dynamic>.from(data?[key]);
      if (value is String) return null;
      if (value is int) return null;
      if (value is bool) return null;
      if (value is double) return null;
      if (value is List) return null;
      return value;
    } catch (error) {
      return null;
    }
  }

  /// 将不确定的类型转换为Object类型 <br>
  ///
  /// @param value ：待转换的类型 <br>
  /// @return 转换后的Object类型 <br>
  static Map<String, dynamic> parseMap(Map<String, dynamic>? data, String key) {
    try {
      var value = Map<String, dynamic>.from(data?[key]);
      if (value is String) return {};
      if (value is int) return {};
      if (value is bool) return {};
      if (value is double) return {};
      if (value is List) return {};
      return value;
    } catch (error) {
      return {};
    }
  }
}
