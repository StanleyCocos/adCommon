import 'package:ad_common/ad_common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 点击回调 index
typedef TagItemTap = Function(int index);

/// 快速创建tagView
class Tags extends StatefulWidget {
  /// 内容列表
  final List tags;

  /// 背景色
  final Color? backgroundColor;

  /// margin
  final EdgeInsets? margin;

  /// padding
  final EdgeInsets? padding;

  /// tag横向间距
  final double spacing;

  /// tag纵向间距
  final double runSpacing;

  /// 点击回调
  final TagItemTap? onTap;

  /// 自定义Tag
  final IndexedWidgetBuilder builder;

  Tags({
    Key? key,
    required this.builder,
    required this.tags,
    this.backgroundColor,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.all(10),
    this.runSpacing = 10,
    this.spacing = 10,
    this.onTap,
  }) : super(key: key);

  @override
  _TagViewState createState() => _TagViewState();
}

class _TagViewState extends State<Tags> {
  @override
  Widget build(BuildContext context) {
    if (widget.tags.length == 0) return SizedBox(width: 0, height: 0);
    return Material(
      child: Container(
        width: double.infinity,
        color: widget.backgroundColor,
        margin: widget.margin,
        padding: widget.padding,
        child: Wrap(
          spacing: widget.spacing,
          runSpacing: widget.runSpacing,
          children: widget.tags.map((res) {
            int index = widget.tags.indexOf(res);
            return widget.builder(context, index);
          }).toList(),
        ),
      ),
    );
  }
}

class TagTextItem extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final BorderSide? borderSide;
  final InteractiveInkFeatureFactory? splashFactory;
  final GestureTapCallback? onTap;

  TagTextItem({
    Key? key,
    required this.text,
    this.style,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.borderSide,
    this.splashFactory,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(padding),
        backgroundColor: MaterialStateProperty.all(
          backgroundColor ?? ColorManager.grayDD,
        ),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          side: borderSide ?? BorderSide.none,
          borderRadius: borderRadius ?? BorderRadius.circular(5),
        )),
        splashFactory: splashFactory,
      ),
      child: Text(
        text,
        style: style ??
            TextStyle(
              color: ColorManager.gray66,
              fontSize: 12,
            ),
      ),
    );
  }
}
