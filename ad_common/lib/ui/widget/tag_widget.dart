import 'package:ad_common/ad_common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 点击回调 index
typedef TagItemTap = Function(int index);

/// 快速创建tagView
class Tags extends StatefulWidget {
  /// 内容列表
  final List tags;

  /// margin
  EdgeInsets? margin;

  /// padding
  EdgeInsets? padding;

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
    this.margin,
    this.padding,
    this.runSpacing = 10,
    this.spacing = 10,
    this.onTap,
  }) : super(key: key) {
    this.padding = this.padding ??
        EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10);
    this.margin = this.margin ?? EdgeInsets.zero;
  }

  @override
  _TagViewState createState() => _TagViewState();
}

class _TagViewState extends State<Tags> {
  @override
  Widget build(BuildContext context) {
    if (widget.tags.length == 0) return Container();
    return Material(
      child: Container(
        width: double.infinity,
        margin: widget.margin,
        padding: widget.padding,
        child: Wrap(
          spacing: widget.spacing,
          runSpacing: widget.runSpacing,
          children: widget.tags.map(
            (res) {
              int i = widget.tags.indexOf(res);
              return widget.builder(context, i);
            },
          ).toList(),
        ),
      ),
    );
  }
}

class TagTextItem extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final TextStyle? style;
  final GestureTapCallback? onTap;
  final Color? splashColor;
  final Color? highlightColor;
  final Color? focusColor;
  final Color? hoverColor;
  final EdgeInsets? padding;

  TagTextItem({
    Key? key,
    required this.text,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.style,
    this.onTap,
    this.splashColor,
    this.highlightColor,
    this.focusColor,
    this.hoverColor,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: backgroundColor ?? ColorManager.grayDD,
        borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(5)),
        border: border,
      ),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Text(
            text,
            style: style ??
                TextStyle(
                  color: ColorManager.gray66,
                  fontSize: 12,
                ),
          ),
        ),
        splashColor: splashColor ?? ColorManager.grayDD,
        highlightColor: highlightColor ?? ColorManager.grayF0,
        hoverColor: hoverColor,
        focusColor: focusColor,
        onTap: onTap,
      ),
    );
  }
}
