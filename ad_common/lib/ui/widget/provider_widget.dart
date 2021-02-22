import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ProviderWidget<T extends ChangeNotifier> extends StatelessWidget {
  final T controller;
  final Widget Function() builder;
  ProviderWidget({this.controller, this.builder});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: controller,
      child: Consumer<T>(
        builder: (BuildContext context, ChangeNotifier provider, _) => builder(),
      ),
    );
  }
}
