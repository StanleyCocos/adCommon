import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';




/// 点击回调 index
typedef TagItemTap = Function(int index);

/// 快速创建tagView
class Tags extends StatefulWidget {

  /// 内容列表
  final List<String> tags;

  /// margin
  EdgeInsets? margin;

  /// padding
  EdgeInsets? padding;

  /// 背景颜色
  final Color backgroundColor;

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
    this.backgroundColor = Colors.white,
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
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        color: widget.backgroundColor,
        margin: widget.margin,
        padding: widget.padding,
        child: Wrap(
          spacing: widget.spacing,
          runSpacing: widget.runSpacing,
          children: widget.tags.map(
                (res) {
              int i = widget.tags.indexOf(res);
              return GestureDetector(
                onTap: ()=> widget.onTap?.call(i),
                child: widget.builder(context, i),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
