import 'package:intl/intl.dart';

///时间-日期 扩展类
extension DateOption on DateTime {

  /*
  * 获取当前毫秒
  * */
  int get nowMillisecond => this.millisecondsSinceEpoch;

  /*
  * 是否为今天
  * */
  bool get isToday {
    final nowDate = DateTime.now();
    return this.year == nowDate.year &&
        this.month == nowDate.month &&
        this.day == nowDate.day;
  }

  /*
  * 是否为昨天
  * */
  bool get isYesterday {
    final nowDate = DateTime.now();
    return this.year == nowDate.year &&
        this.month == nowDate.month &&
        this.day == nowDate.day - 1;
  }

  /*
  * 是否为月份的第一天
  * */
  bool get isFirstDayOfMonth => isSameDay(firstDayOfMonth, this);

  /*
  * 是否为月份的最后一天
  * */
  bool get isLastDayOfMonth => isSameDay(lastDayOfMonth, this);

  /*
  * 获取月份的第一天
  * */
  DateTime get firstDayOfMonth => DateTime(this.year, this.month);

  /*
  * 获取指定格式的当前时间
  * */
  String format({String format = "yyyy-MM-dd HH:mm:ss"}) {
    return DateFormat(format).format(this);
  }

  /*
  * 获取月份的最后一天
  * */
  DateTime get lastDayOfMonth {
    var beginningNextMonth = (this.month < 12)
        ? DateTime(this.year, this.month + 1, 1)
        : DateTime(this.year + 1, 1, 1);
    return beginningNextMonth.subtract(Duration(days: 1));
  }

  /*
  * 获取周的第一天
  * */
  DateTime get firstDayOfWeek {
    final day = DateTime.utc(this.year, this.month, this.day, 12);
    var decreaseNum = day.weekday % 7;
    return this.subtract(Duration(days: decreaseNum));
  }

  /*
  * 获取周的最后一天
  * */
  DateTime get lastDayOfWeek {
    final day = DateTime.utc(this.year, this.month, this.day, 12);
    var increaseNum = day.weekday % 7;
    return day.add(Duration(days: 7 - increaseNum));
  }

  /*
  * 获取月份的天数列表
  * */
  List<DateTime> get daysInMonth {
    var first = firstDayOfMonth;
    var daysBefore = first.weekday;
    var firstToDisplay = first.subtract(Duration(days: daysBefore));
    var last = lastDayOfMonth;
    var daysAfter = 7 - last.weekday;
    if (daysAfter == 0) {
      daysAfter = 7;
    }
    var lastToDisplay = last.add(Duration(days: daysAfter));
    return daysInRange(firstToDisplay, lastToDisplay).toList();
  }

  /*
  * 获取前一个月时间
  * */
  DateTime get previousMonth {
    var year = this.year;
    var month = this.month;
    if (month == 1) {
      year--;
      month = 12;
    } else {
      month--;
    }
    return DateTime(year, month);
  }

  /*
  * 获取后一个月时间
  * */
  DateTime get nextMonth {
    var year = this.year;
    var month = this.month;

    if (month == 12) {
      year++;
      month = 1;
    } else {
      month++;
    }
    return DateTime(year, month);
  }

  /*
  * 获取前一周
  * */
  DateTime get previousWeek => this.subtract(Duration(days: 7));

  /*
  * 获取下一周
  * */
  DateTime get nextWeek => this.add(Duration(days: 7));

  /*
  *  获取指定范围的时间
  * */
  static Iterable<DateTime> daysInRange(DateTime start, DateTime end) sync* {
    var i = start;
    var offset = start.timeZoneOffset;
    while (i.isBefore(end)) {
      yield i;
      i = i.add(Duration(days: 1));
      var timeZoneDiff = i.timeZoneOffset - offset;
      if (timeZoneDiff.inSeconds != 0) {
        offset = i.timeZoneOffset;
        i = i.subtract(Duration(seconds: timeZoneDiff.inSeconds));
      }
    }
  }

  /*
  * 是否同一周
  * */
  static bool isSameWeek(DateTime a, DateTime b) {
    a = DateTime.utc(a.year, a.month, a.day);
    b = DateTime.utc(b.year, b.month, b.day);

    var diff = a.toUtc().difference(b.toUtc()).inDays;
    if (diff.abs() >= 7) {
      return false;
    }

    var min = a.isBefore(b) ? a : b;
    var max = a.isBefore(b) ? b : a;
    var result = max.weekday % 7 - min.weekday % 7 >= 0;
    return result;
  }

  /*
  * 是否同一天
  * */
  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /*
  * num 转 string
  * 通常用于倒计时
  * 显示格式：02:34:58
  * */
  static String numToStringTime(num curTime) {
    if (curTime <= 0) return "00:00:00";
    int hour = curTime ~/ 3600;
    int minutes = (curTime - hour * 3600) ~/ 60;
    int seconds = curTime % 60 as int;
    String hourValue;
    if (hour == 0) {
      hourValue = "00";
    } else if (hour > 0 && hour < 10) {
      hourValue = "0$hour";
    } else {
      hourValue = "$hour";
    }

    String minutesValue;
    if (minutes == 0) {
      minutesValue = "00";
    } else if (minutes > 0 && minutes < 10) {
      minutesValue = "0$minutes";
    } else {
      minutesValue = "$minutes";
    }

    String secondsValue;
    if (seconds == 0) {
      secondsValue = "00";
    } else if (seconds > 0 && seconds < 10) {
      secondsValue = "0$seconds";
    } else {
      secondsValue = "$seconds";
    }
    return "$hourValue:$minutesValue:$secondsValue";
  }

  /*
  * num 转 string
  * 通常用于倒计时
  * 显示格式：1天2小時58分鐘
  * */
  static String numToStringTimeByDayHourMinute(var time) {
    int curTime = 0;
    if (time is int) {
      curTime = time;
    } else if (time is String) {
      curTime = int.parse(time);
    }

    if (curTime <= 0) return "0分鐘";
    int day = curTime ~/ (24 * 3600);
    int hour = (curTime - day * 24 * 3600) ~/ 3600;
    int minute = (curTime - day * 24 * 3600 - hour * 3600) ~/ 60;

    String value = "";
    if (day > 0) {
      value += "$day天";
    }
    if (hour > 0) {
      value += "$hour小時";
    }
    if (minute > 0) {
      value += "$minute分鐘";
    }
    return value;
  }

  /*
  * 格式化
  * */
  String string({String format = "yyyy-MM-dd HH:mm:ss", bool addZone = false}) {
    var time = format;
    var date = DateTime.now();
    int tempYear = date.year;
    int tempMonth = date.month;
    int tempDay = date.day;
    int tempHour = date.hour;
    int tempMinute = date.minute;
    int tempSecond = date.second;
    time = format.replaceAll("yyyy", '$tempYear');
    if (addZone) {
      if (tempMonth > 9) {
        time = time.replaceAll("MM", '$tempMonth');
      } else {
        time = time.replaceAll("MM", '0$tempMonth');
      }
      if (tempDay > 9) {
        time = time.replaceAll("dd", '$tempDay');
      } else {
        time = time.replaceAll("dd", '0$tempDay');
      }
      if (tempHour > 9) {
        time = time.replaceAll("HH", '$tempHour');
      } else {
        time = time.replaceAll("HH", '0$tempHour');
      }
      if (tempMinute > 9) {
        time = time.replaceAll("mm", '$tempMinute');
      } else {
        time = time.replaceAll("mm", '0$tempMinute');
      }
      if (tempSecond > 9) {
        time = time.replaceAll("ss", '$tempSecond');
      } else {
        time = time.replaceAll("ss", '0$tempSecond');
      }
    } else {
      time = time.replaceAll("MM", '$tempMonth');
      time = time.replaceAll("dd", '$tempDay');
      time = time.replaceAll("HH", '$tempHour');
      time = time.replaceAll("mm", '$tempMinute');
      time = time.replaceAll("ss", '$tempSecond');
    }
    return time;
  }
}
