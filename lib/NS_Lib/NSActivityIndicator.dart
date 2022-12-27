import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'NSReturnFromRender.dart';

// ignore: non_constant_identifier_names
Widget NSActivityIndicator({bool animating, double radius = 10, Color color}) {
  final Widget ind = CupertinoActivityIndicator(
    animating: animating,
    radius: radius,
  );
  final Widget ios = animating
      ? color != null
          ? ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(colors: [color], stops: [0])
                    .createShader(bounds);
              },
              child: ind)
          : ind
      : null;

  // final double androidRadius = radius * 3.7;
  final double androidRadius = radius * 2.5;
  Widget android = animating
      ? Container(
          height: androidRadius,
          width: androidRadius,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        )
      : null;

  return NSReturnFromRender<Widget>(null,
      ios: ios, android: android, web: ios, kDefault: ios);
}
