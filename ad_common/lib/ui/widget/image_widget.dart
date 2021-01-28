import 'package:ad_common/common/global/enum_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class ImageManager {
  static const FILE_PTH = "assets/images/";

  static Image name(
      String name, {
        String path = "",
        double width = 24.0,
        double height = 24.0,
        String type = ".png",
        BoxFit fit = BoxFit.contain,
      }) {
    String imagePath =
        FILE_PTH + path + name + type;
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
    );
  }

  static ImageIcon nameIcon(
      String name, {
        String path = "",
        double size = 24.0,
        String type = ".png",
        Color color = Colors.black,
      }) {
    String imagePath =
        FILE_PTH + path + name + type;
    return ImageIcon(AssetImage(imagePath), color: color, size: size);
  }

  static String path(
      String name, {
        String path = "placeholder/",
        String type = ".png",
      }) {
    String imagePath =
        FILE_PTH + path + name + type;
    return imagePath;
  }

  static Image placeholder(
      String name, {
        String path = "",
        String type = ".png",
        double width = double.infinity,
        double height = double.infinity,
        BoxFit fit = BoxFit.contain,
      }) {
    String imagePath =
        FILE_PTH + path + name + type;
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
    );
  }
}