import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'NSButton.dart';
import 'NSReturnFromRender.dart';

class NSRaisedButton extends StatelessWidget {
  final Widget body;
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color lightColor;
  final Color darkColor;
  final Color disabledColor;
  final num pressedOpacity;
  final BorderRadius borderRadius;
  final Color androidSplashColor;

  static NSRaisedButton stdPadd(
      {@required body,
      padding = const EdgeInsets.fromLTRB(0, 16, 0, 16),
      color,
      disabledColor = CupertinoColors.quaternarySystemFill,
      pressedOpacity = 0.4,
      borderRadius = const BorderRadius.all(Radius.circular(8.0)),
      @required onPressed,
      onLongPress,
      lightColor,
      darkColor,
      androidSplashColor}) {
    return NSRaisedButton(
        body: body,
        padding: padding,
        color: color,
        disabledColor: disabledColor,
        pressedOpacity: pressedOpacity,
        borderRadius: borderRadius,
        onPressed: onPressed,
        onLongPress: onLongPress,
        lightColor: lightColor,
        darkColor: darkColor,
        androidSplashColor: androidSplashColor);
  }

  static NSRaisedButton inverted(
      {@required body,
      padding = const EdgeInsets.fromLTRB(0, 16, 0, 16),
      color,
      disabledColor = CupertinoColors.quaternarySystemFill,
      pressedOpacity = 0.4,
      borderRadius = const BorderRadius.all(Radius.circular(8.0)),
      @required onPressed,
      onLongPress,
      lightColor,
      darkColor,
      androidSplashColor}) {
    return NSRaisedButton(
        body: body,
        padding: padding,
        color: color,
        disabledColor: disabledColor,
        pressedOpacity: pressedOpacity,
        borderRadius: borderRadius,
        onPressed: onPressed,
        onLongPress: onLongPress,
        lightColor: darkColor,
        darkColor: lightColor,
        androidSplashColor: androidSplashColor);
  }

  NSRaisedButton kInverted() {
    return NSRaisedButton(
        body: body,
        padding: padding,
        color: color,
        disabledColor: disabledColor,
        pressedOpacity: pressedOpacity,
        borderRadius: borderRadius,
        onPressed: onPressed,
        onLongPress: onLongPress,
        lightColor: darkColor,
        darkColor: lightColor,
        androidSplashColor: androidSplashColor);
  }

  NSRaisedButton(
      {Key key,
      @required this.body,
      this.padding,
      this.color,
      this.disabledColor = CupertinoColors.quaternarySystemFill,
      this.pressedOpacity = 0.4,
      this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
      @required this.onPressed,
      this.onLongPress,
      this.lightColor,
      this.darkColor,
      this.androidSplashColor});

  @override
  Widget build(BuildContext context) {
    final Color _color =
        MediaQuery.of(context).platformBrightness == Brightness.light
            ? (lightColor ?? color)
            : (darkColor ?? color);

    final shadowColor =
        MediaQuery.of(context).platformBrightness == Brightness.light
            ? (Colors.black)
            : (Colors.grey[900]);
    Widget ios = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: shadowColor, blurRadius: 1, offset: Offset(0, 1))
        ],
      ),
      child: NSButton(
        padding: padding, //EdgeInsets.fromLTRB(0, 16, 0, 16),
        color: _color ?? Colors.blue,
        body: body,
        onPressed: () {
          this.onPressed();
        },
      ),
    );

    // Widget ios = CupertinoButton(
    //   child: body,
    //   padding: padding,
    //   color: _color,
    //   disabledColor: disabledColor,
    //   pressedOpacity: pressedOpacity,
    //   borderRadius: borderRadius,
    //   onPressed: onPressed,
    // );

    Widget android = RaisedButton(
      color: _color,
      splashColor: androidSplashColor,
      child: body,
      padding: padding,
      onPressed: this.onPressed,
      onLongPress: this.onLongPress,
    );
    return NSReturnFromRender(context,
        ios: ios, android: android, web: ios, kDefault: ios);
  }
}
