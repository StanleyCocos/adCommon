// ignore: missing_return
T asT<T>(Map<String, dynamic> json, String key, {T defaultValue}) {
  dynamic value = json[key];
  if (value is T) return value;

  if (0 is T) {
    defaultValue = 0 as T;
    if (value is double)
      return value.toInt() as T;
    else if (value is bool)
      return value ? 1 : 0 as T;
    else if (value is String)
      return int.tryParse(value) ??
          double.tryParse(value)?.toInt() ??
          defaultValue;
    else
      return defaultValue;
  } else if (0.0 is T) {
    defaultValue = 0.0 as T;
    if (value is int)
      return value.toDouble() as T;
    else if (value is bool)
      return value ? 1.0 : 0.0 as T;
    else if (value is String)
      return double.tryParse(value) ?? defaultValue;
    else
      return defaultValue;
  } else if ('' is T) {
    defaultValue = '' as T;
    return value.toString() ?? defaultValue;
  } else if (false is T) {
    defaultValue = false as T;
    String valueS = value.toString();
    if (valueS == '1' || valueS == '1.0' || valueS.toLowerCase() == 'true')
      return true as T;
    return defaultValue;
  } else if (List is T) {
    return [] as T;
  } else if (Map is T) {
    return Map() as T;
  }
  return null;
}
