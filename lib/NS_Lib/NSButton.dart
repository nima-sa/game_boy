import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'NSReturnFromRender.dart';

class NSButton extends StatelessWidget {
  final Widget body;
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry androidPadding;
  final Color color;
  final Color lightColor;
  final Color darkColor;
  final Color disabledColor;
  final num pressedOpacity;
  final BorderRadius borderRadius;

  NSButton(
      {Key key,
      @required this.body,
      this.padding,
      this.androidPadding,
      this.color,
      this.disabledColor = CupertinoColors.quaternarySystemFill,
      this.pressedOpacity = 0.4,
      this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
      @required this.onPressed,
      this.onLongPress,
      this.lightColor,
      this.darkColor});

  @override
  Widget build(BuildContext context) {
    final Color _color =
        MediaQuery.of(context).platformBrightness == Brightness.light
            ? (lightColor ?? color)
            : (darkColor ?? color);
    Widget ios = CupertinoButton(
      child: body,
      padding: padding,
      color: _color,
      disabledColor: disabledColor,
      pressedOpacity: pressedOpacity,
      borderRadius: borderRadius,
      onPressed: onPressed,
    );
    Widget android = FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: BorderSide(color: Colors.white, width: 0)),
      child: body,
      onPressed: onPressed,
      onLongPress: onLongPress,
      padding: androidPadding ?? padding,
      color: _color,
    );

    return NSReturnFromRender(context,
        ios: ios, android: android, web: ios, kDefault: ios);
  }
}
