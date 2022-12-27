import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'NSReturnFromRender.dart';

class NSIcon extends StatelessWidget {
  final IconData icon;
  final Color lightColor;
  final Color darkColor;

  NSIcon(
    this.icon, {
    this.lightColor,
    this.darkColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = MediaQuery.of(context).platformBrightness == Brightness.light
        ? (lightColor ?? Colors.black)
        : (darkColor ?? Colors.white);

    Widget ios = Icon(icon, color: color, size: 25);

    Widget android = Icon(icon, color: color);

    return NSReturnFromRender(context,
        ios: ios, android: android, web: ios, kDefault: ios);
  }
}
