import 'package:flutter/material.dart';

/// 状态页面
class CommonStatePage extends StatelessWidget {
  final Widget image;
  final String text;
  final double? textSize;
  final double? width;
  final double? height;

  CommonStatePage({
    Key? key,
    required this.image,
    this.text = "",
    this.textSize,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          image,
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text(
              text,
              style: TextStyle(
                color: Color(0xFF999999),
                fontSize: textSize ?? 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}
