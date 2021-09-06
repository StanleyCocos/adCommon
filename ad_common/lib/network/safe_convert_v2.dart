T? asT<T>(Map<String, dynamic>? json, String key, {T? defaultValue}) {
  if (json != null && json[key] is T) return json[key];

  if (0 is T) {
    if (defaultValue == null) defaultValue = 0 as T;
    if (json == null) return defaultValue;
    dynamic value = json[key];
    if (value is double)
      return value.toInt() as T;
    else if (value is bool)
      return value ? 1 as T? : 0 as T;
    else if (value is String)
      return int.tryParse(value) as T? ??
          double.tryParse(value)?.toInt() as T? ??
          defaultValue;
    else
      return defaultValue;
  } else if (0.0 is T) {
    if (defaultValue == null) defaultValue = 0.0 as T;
    if (json == null) return defaultValue;
    dynamic value = json[key];
    if (value is int)
      return value.toDouble() as T;
    else if (value is bool)
      return value ? 1.0 as T? : 0.0 as T;
    else if (value is String)
      return double.tryParse(value) as T? ?? defaultValue;
    else
      return defaultValue;
  } else if ('' is T) {
    if (defaultValue == null) defaultValue = '' as T;
    if (json == null) return defaultValue;
    dynamic value = json[key];
    return value.toString() as T;
  } else if (false is T) {
    if (defaultValue == null) defaultValue = false as T;
    if (json == null) return defaultValue;
    dynamic value = json[key];
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

T? asObject<T>() {
  if (0 is T) return 0 as T;
  if (0.0 is T) return 0.0 as T;
  if ('' is T) return '' as T;
  if (false is T) return false as T;
  if (List is T) return [] as T;
  if (Map is T) return Map() as T;
  return null;
}