class RegexManager {
  /// 校验函数
  static bool verify(String content, String regex) {
    if (content == null || content.isEmpty) return false;
    return RegExp(regex).hasMatch(content);
  }

  /// 是否全部为数字
  static bool isNumber(String content) {
    return verify(content, r"^\d*$");
  }

  /// 是否全部为汉字
  static bool isChinese(String content) {
    return verify(content, r"^[\u4e00-\u9fa5]*$");
  }

  /// 是否为汉字加字母
  static bool isChineseAndEnglish(String content) {
    return verify(content, r"^[a-zA-Z\u4e00-\u9fa5]+$");
  }

  /// 是否为汉字加字母加数字
  static bool isChineseAndEnglishOrNumber(String content) {
    return verify(content, r"^[0-9a-zA-Z\u4e00-\u9fa5]+$");
  }

  /// 是否为汉字加字母加空格
  static bool isChineseAndEnglishOrSpace(String content) {
    return verify(content, r"^[a-zA-Z\s\u4e00-\u9fa5]+$");
  }

  /// 是否为URL
  static bool isUrl(String content) {
    return verify(content,
        r"^(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]");
  }

  /// 是否存在特殊字符
  static bool isSpecialChar(String content) {
    return verify(content, r"[^\w\s]+");
  }

  /// 是否为台湾电话
  static bool isTaiWanPhone(String content) {
    return verify(content, r"^09([0-9]{8})$");
  }

  /// 是否为邮箱
  static bool isEmail(String content){
    return verify(content, "^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+\$");
  }
}
