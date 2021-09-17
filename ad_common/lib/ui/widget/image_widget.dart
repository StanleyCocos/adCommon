import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ad_common/common/extension/string_extension.dart';


class ImageManager {

  static String _root = "assets/images/";

  static void init(String path) => _root = path;

  static Image name(
      Object name, {
        String path = "",
        double width = 24.0,
        double height = 24.0,
        double? size,
        String type = ".png",
        BoxFit fit = BoxFit.contain,
      }) {
    String imagePath =
        _root + path + _transformName(name) + type;
    return Image.asset(
      imagePath,
      width: size ?? width,
      height: size ?? height,
      fit: fit,
    );
  }

  static ImageIcon icon(
      Object name, {
        String path = "icon/",
        double size = 24.0,
        String type = ".png",
        Color color = Colors.black,
      }) {
    String imagePath =
        _root + path + _transformName(name) + type;
    return ImageIcon(AssetImage(imagePath), color: color, size: size);
  }

  static Image placeholder(
      Object name, {
        String path = "placeholder/",
        String type = ".png",
        double width = double.infinity,
        double height = double.infinity,
        BoxFit fit = BoxFit.contain,
      }) {
    String imagePath =
        _root + path + _transformName(name) + type;
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
    );
  }


  static String path(
      Object name, {
        String path = "",
        String type = ".png",
      }) {
    String imagePath =
        _root + path + _transformName(name) + type;
    return imagePath;
  }

  static String _transformName(Object name) {
    if(name is String) return name;
    return name.toString().enumRowValue;
  }

}