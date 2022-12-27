import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'NSReturnFromRender.dart';

import 'NSButton.dart';

class NSIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color disabledColor;
  final num pressedOpacity;
  final Color iconColor;
  final Color lightIconColor;
  final Color darkIconColor;
  final BorderRadius borderRadius;

  NSIconButton(
      {Key key,
      @required this.icon,
      this.padding,
      this.backgroundColor,
      this.iconColor = Colors.black,
      this.lightIconColor,
      this.darkIconColor,
      this.disabledColor = CupertinoColors.quaternarySystemFill,
      this.pressedOpacity = 0.4,
      this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
      @required this.onPressed,
      this.onLongPress});

  @override
  Widget build(BuildContext context) {
    Widget ios;
    Widget defaultRender;
    final _color = MediaQuery.of(context).platformBrightness == Brightness.light
        ? lightIconColor ?? iconColor
        : darkIconColor ?? iconColor;
    ios = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3000),
        color: backgroundColor,
      ),
      // child: ShaderMask(
      // shaderCallback: (Rect bounds) {
      // return LinearGradient(colors: [_color], stops: [0])
      // .createShader(bounds);
      // },
      child: NSButton(
        body: kIsWeb
            ? icon
            : ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(colors: [_color], stops: [0])
                      .createShader(bounds);
                },
                child: icon),
        padding: padding,
        // color: iconColor,x
        disabledColor: disabledColor,
        onPressed: () {
          this.onPressed();
        },
      ),
      // ),
    );

    defaultRender = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3000),
        color: backgroundColor,
        // boxShadow: [
        // BoxShadow(blurRadius: 5, offset: Offset(0, 1), color: Colors.black)
        // ],
      ),
      child: IconButton(
        icon: icon,
        color: _color,
        disabledColor: disabledColor,
        onPressed: () {
          this.onPressed();
        },
      ),
    );
    return NSReturnFromRender(context,
        ios: ios, android: defaultRender, web: ios, kDefault: ios);
  }
}
