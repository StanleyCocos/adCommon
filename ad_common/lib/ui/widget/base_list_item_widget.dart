import 'package:flutter/cupertino.dart';

typedef ListItemCallback<T> = void Function(T model, int index);

class BaseListItemWidget<T> extends StatelessWidget {
  final T model;
  final int position;
  final ListItemCallback<T>? onTap;

  Widget? get content => null;

  BaseListItemWidget({
    required this.model,
    required this.position,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(model, position),
      child: content,
    );
  }
}
