import 'package:ad_common/ad_common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension STDoubleExtension on double {
  Widget get paddingAll {
    return Padding(
      padding: EdgeInsets.all(this),
    );
  }

  Widget get paddingT {
    return Padding(
      padding: EdgeInsets.only(top: this),
    );
  }

  Widget get paddingB {
    return Padding(
      padding: EdgeInsets.only(bottom: this),
    );
  }

  Widget get paddingL {
    return Padding(
      padding: EdgeInsets.only(left: this),
    );
  }

  Widget get paddingR {
    return Padding(
      padding: EdgeInsets.only(right: this),
    );
  }

  Widget divider(Color color) {
    return Divider(
      color: color,
      thickness: this,
    );
  }
}

extension STListExtension on List<Widget> {
  Widget row({
    MainAxisAlignment maa = MainAxisAlignment.start,
    CrossAxisAlignment caa = CrossAxisAlignment.center,
  }) {
    return Row(
      mainAxisAlignment: maa,
      crossAxisAlignment: caa,
      children: this,
    );
  }

  Widget column({
    MainAxisAlignment maa = MainAxisAlignment.start,
    CrossAxisAlignment caa = CrossAxisAlignment.center,
  }) {
    return Column(
      mainAxisAlignment: maa,
      crossAxisAlignment: caa,
      children: this,
    );
  }
}

extension STPaddingExtension on Widget {
  Widget padding(EdgeInsets insets) {
    return Padding(
      padding: insets,
      child: this,
    );
  }

  Widget paddingAll(double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: this,
    );
  }
}

extension STTapExtension on Widget {
  Widget onTap(GestureTapCallback? callback) {
    return GestureDetector(
      onTap: callback,
      behavior: HitTestBehavior.opaque,
      child: this,
    );
  }
}

extension STMarginExtension on Widget {
  Widget margin(EdgeInsets insets) {
    return Container(
      margin: insets,
      child: this,
    );
  }

  Widget marginAll(double margin) {
    return Container(
      margin: EdgeInsets.all(margin),
      child: this,
    );
  }
}

extension STProviderExtension on Widget {
  Widget provider(ChangeNotifier controller) {
    return ProviderWidget(
      controller: controller,
      builder: () => this,
    );
  }
}

extension STExpandExtension on Widget {
  Widget expand({int flex = 1}) {
    return Expanded(
      child: this,
      flex: flex,
    );
  }
}

extension STOffsetExtension on Widget {
  Widget offstage(bool show) {
    return Offstage(
      offstage: show,
      child: this,
    );
  }
}

extension STPositionExtension on Widget {
  Widget position({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: this,
    );
  }
}


extension STSizeExtension on Widget {
  Widget size(Size size){
    return SizedBox(
      width: size.width,
      height: size.height,
      child: this,
    );
  }
}


extension STColorExtension on Widget {

  Widget color(Color color){
    return Container(
      child: this,
      color: color,
    );
  }
}

extension STRadiusWidgetExtension on Widget {

  Widget radius(double radius){
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius.bAll,
      ),
      child: this,
    );
  }

  Widget border(double border, {Color? color}){
    color ??=  ColorManager.hexColor(0xEEEEEE);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: border, color: color),
      ),
      child: this,
    );
  }
}


extension STRadiusExtension on double {

  Radius get r => Radius.circular(this);

}

extension STBorderRadiusExtension on double {

  BorderRadiusGeometry get bAll => BorderRadius.all(this.r);

  BorderRadiusGeometry get bBL => BorderRadius.only(bottomLeft: this.r);

  BorderRadiusGeometry get bTL => BorderRadius.only(topLeft: this.r);

  BorderRadiusGeometry get bBR => BorderRadius.only(bottomRight: this.r);

  BorderRadiusGeometry get bTR => BorderRadius.only(topRight: this.r);

  BorderRadiusGeometry get bT => BorderRadius.only(topRight: this.r, topLeft: this.r);

  BorderRadiusGeometry get bB => BorderRadius.only(bottomRight: this.r, bottomLeft: this.r);

  BorderRadiusGeometry get bL => BorderRadius.only(topLeft: this.r, bottomLeft: this.r);

  BorderRadiusGeometry get bR => BorderRadius.only(topRight: this.r, bottomRight: this.r);
}





