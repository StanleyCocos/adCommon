///校验管理类
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

  /// 是否包含为数字
  static bool hasNumber(String content) {
    return verify(content, r"\d");
  }

  /// 是否全部为汉字
  static bool isChinese(String content) {
    return verify(content, r"^[\u4e00-\u9fa5]*$");
  }

  /// 是否包含为汉字
  static bool hasChinese(String content) {
    return verify(content, r"[\u4e00-\u9fa5]");
  }

  /// 是否全部为字母
  static bool isLetter(String content) {
    return verify(content, r"^[a-zA-Z]*$");
  }

  /// 是否包含为字母
  static bool hasLetter(String content) {
    return verify(content, r"[a-zA-Z]");
  }

  /// 是否包含符号
  static bool hasSymbol(String content) {
    return verify(content, "[`~!@#\$%^&*()_\-+=<>?:\"{}|,.//\/;'\\[\]·~！@#￥%……&*（）——\-+={}|《》？：“”【】、；‘’，。、]");
  }

  /// 是否为汉字加字母(全字母、全汉字、字母与汉字组合)
  static bool isChineseAndEnglish(String content) {
    return verify(content, r"^[a-zA-Z\u4e00-\u9fa5]+$");
  }

  /// 是否为汉字加字母加数字(全字母、全汉字、全数字、字母与数字与汉字组合)
  static bool isChineseAndEnglishOrNumber(String content) {
    return verify(content, r"^[0-9a-zA-Z\u4e00-\u9fa5]+$");
  }

  /// 是否为汉字加字母加空格(全汉字、全字母、全空格、汉字与字母与空格组合)
  static bool isChineseAndEnglishOrSpace(String content) {
    return verify(content, r"^[a-zA-Z\s\u4e00-\u9fa5]+$");
  }

  ///由字母或数字开头  内容由字母、数字、下划线组成
  static bool isNumberAndLetterStar(String content) {
    return verify(content, r"^[a-zA-Z0-9][a-zA-Z0-9_]+$");
  }

  /// 是否为URL
  static bool isUrl(String content) {
    return verify(content, r"^(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]");
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
  static bool isEmail(String content) {
    return verify(content, "^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+\$");
  }
}
