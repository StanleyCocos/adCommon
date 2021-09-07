







import 'package:flutter/material.dart';

T asT<T>(Map<String, dynamic>? json, String key, {T? defaultValue}) {
  if (json != null && json[key] is T) return json[key];
  if (0 is T) {
    return asInt(json, key: key, defaultValue: defaultValue != null ? defaultValue as int : 0) as T;
  } else if (0.0 is T) {
    return asDouble(json, key: key, defaultValue: defaultValue != null ? defaultValue as double: 0.0) as T;
  } else if ('' is T) {
    return asString(json, key: key, defaultValue: defaultValue != null ? defaultValue as String : "") as T;
  } else if (false is T) {
    return asBool(json, key: key, defaultValue: defaultValue != null ? defaultValue as bool : false) as T;
  } else if ([] is T) {
    return asList(json, key: key, defaultValue: defaultValue != null ? defaultValue as List<Object> : []) as T;
  } else if ({} is T) {
    return asMap(json, key: key, defaultValue: defaultValue != null ? defaultValue as Map : {}) as T;
  }
  return Object() as T;
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


int asInt(Map<String, dynamic>? json, {required String key, int defaultValue = 0}){
  try{
    if(json == null || !json.containsKey(key)) return defaultValue;
    var value = json[key];
    if(value == null) return defaultValue;
    if(value is double) return value.toInt();
    if(value is bool) return value ? 1 : 0;
    if(value is String) return (int.parse(value) is int) ? int.parse(value) : defaultValue;
    if(value is int) return value;
    return defaultValue;
  }catch(e){
    return defaultValue;
  }
}

double asDouble(Map<String, dynamic>? json, {required String key, double defaultValue = 0.0}){
  try{
    if(json == null|| !json.containsKey(key)) return defaultValue;
    var value = json[key];
    if(value == null) return defaultValue;
    if(value is int) return value.toDouble();
    if(value is bool) return value ? 1.0 : 0.0;
    if(value is String) return (double.parse(value) is double) ? double.parse(value) : defaultValue;
    if(value is double) return value;
    return defaultValue;
  } catch(e){
    return defaultValue;
  }
}

bool asBool(Map<String, dynamic>? json, {required String key, bool defaultValue = false}){
  try{
    if(json == null || !json.containsKey(key)) return defaultValue;
    var value = json[key];
    if(value == null) return defaultValue;
    if(value is int) return value == 0 ? false : true;
    if(value is String) return value == "true";
    if(value is double) return value == 0 ? false : true;
    if(value is bool) return value;
    return defaultValue;
  } catch(e){
    return defaultValue;
  }
}

String asString(Map<String, dynamic>? json, {required String key, String defaultValue = ""}){
  try{
    if(json == null || !json.containsKey(key)) return defaultValue;
    var value = json[key];
    if(value == null) return defaultValue;
    if(value is int) return value.toString();
    if(value is double) return value.toString();
    if(value is bool) return value ? "true" : "false";
    if(value is String) return value;
    return defaultValue;
  } catch(e){
    return defaultValue;
  }
}

Map asMap(Map<String, dynamic>? json, {required String key, Map? defaultValue}){
  try{
    if(json == null || !json.containsKey(key)) return defaultValue ?? {};
    var value = json[key];
    if(value == null) return defaultValue ?? {};
    if(value is Map) return value;
    return defaultValue ?? {};
  } catch(e){
    return defaultValue ?? {};
  }
}


List asList(Map<String, dynamic>? json, {required String key, List? defaultValue}){
  try{
    if(json == null || !json.containsKey(key)) return defaultValue ?? [];
    var value = json[key];
    if(value == null) return defaultValue ?? [];
    if(value is List) return value;
    return defaultValue ?? [];
  } catch (e){
    return defaultValue ?? [];
  }
}

List<String> asListStr(Map<String, dynamic>? json, {required String key, List<String>? defaultValue}){
  try{
    if(json == null || !json.containsKey(key)) return defaultValue ?? [];
    var value = json[key];
    if(value == null) return defaultValue ?? [];
    if(value is List<String>) return value;
    return defaultValue ?? [];
  } catch(e){
    return defaultValue ?? [];
  }
}

