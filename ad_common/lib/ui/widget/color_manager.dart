import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorManager {

  static Color color(int value) {
    return Color(value);
  }

  static Color hexColor(int hex, {double alpha = 1}) {
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    return Color.fromRGBO((hex & 0xFF0000) >> 16, (hex & 0x00FF00) >> 8,
        (hex & 0x0000FF) >> 0, alpha);
  }

  static Color hexFrom(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static Color transparent({double alpha = 0}) {
    return hexColor(0x000000, alpha: alpha);
  }

  static Color get random {
    return Color.fromRGBO(Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 1);
  }

  static Color get black => hexColor(0x000000, alpha: 1);

  static Color get white => hexColor(0xFFFFFF, alpha: 1);

  static Color get bg => hexColor(0xF7F5F6);

  static Color get divider => hexColor(0xF6F6F6);

  static Color get green => hexColor(0x55A32A);

  static Color get greenE4 => hexColor(0xE4F3E5);

  static Color get green4C => hexColor(0x4CD964);

  static Color get green25 => hexColor(0x25C489);

  static Color get pink => hexColor(0xEB6877);

  static Color get red => hexColor(0xFF0000);

  static Color get redFD => hexColor(0xFDEEEC);

  static Color get redE9 => hexColor(0xE94E3C);

  static Color get blue => hexColor(0x2196F3);

  static Color get gray => hexColor(0x9E9E9E);

  static Color get gray33 => hexColor(0x333333);

  static Color get gray4D => hexColor(0x4D4D4D);

  static Color get gray66 => hexColor(0x666666);

  static Color get gray99 => hexColor(0x999999);

  static Color get grayB3 => hexColor(0xB3B3B3);

  static Color get grayB6 => hexColor(0xB6B6B6);

  static Color get grayCC => hexColor(0xCCCCCC);

  static Color get grayDD => hexColor(0xDDDDDD);

  static Color get grayE6 => hexColor(0xE6E6E6);

  static Color get grayEE => hexColor(0xEEEEEE);

  static Color get grayF0 => hexColor(0xF0F0F0);

  static Color get grayF456 => hexColor(0xF4F5F6);

  static Color get grayF6 => hexColor(0xF6F6F6);

  static Color get grayFA => hexColor(0xFAFAFA);
}
