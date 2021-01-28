import 'package:flutter/cupertino.dart';


typedef ListItemCallback<T> = void Function(T model, int index);

 class BaseListItemWidget<T> extends StatelessWidget {
  final T model;
  final int position;
  final ListItemCallback<T> onClick;
  Widget get content => null;

  BaseListItemWidget({
    this.onClick,
    this.model,
    this.position,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> onClick(model, position),
      child: content,
    );
  }
}
