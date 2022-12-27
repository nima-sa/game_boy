import 'package:flutter/material.dart';
import 'package:game_boy/NS_Lib/NSLocalizer.dart';
import 'package:game_boy/NS_Lib/NSReturnFromRender.dart';
// I didn't wrap them in a function to have the 'context' parameter

class NScaptiveTextNavBar extends StatelessWidget {
  final String text;
  final Color lightColor;
  final Color darkColor;
  final Color color;
  final TextStyle style;
  final String fontFamily;
  final bool ignoreColorsIfNull;

  final TextDirection textDirection;
  final TextAlign textAlign;
  final FontWeight weight;
  final double size;

  NScaptiveTextNavBar(
    this.text, {
    this.color,
    this.size,
    this.weight,
    this.lightColor,
    this.darkColor,
    this.textDirection,
    this.textAlign = TextAlign.center,
    this.style = const TextStyle(),
    this.ignoreColorsIfNull = true,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return NSText(text,
        size: 20,
        weight: FontWeight.bold,
        lightColor: lightColor,
        darkColor: darkColor,
        color: color,
        ignoreColorsIfNull: true,
        ignoreMaterial: true,
        fontFamily: fontFamily);
  }
}

class NSCaptiveTextAlertTitle extends StatelessWidget {
  final String text;
  NSCaptiveTextAlertTitle(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: NSText(
        text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class NScaptiveTextActionSheetAlertTitle extends StatelessWidget {
  final String text;
  NScaptiveTextActionSheetAlertTitle(this.text);
  @override
  Widget build(BuildContext context) {
    return NSText(
      text,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class NSText extends StatelessWidget {
  static String fontfamily;
  final String fontFamily;
  final String text;
  final Color lightColor;
  final Color darkColor;
  final Color color;
  final TextDirection textDirection;
  final TextAlign textAlign;
  final TextStyle style;
  final FontWeight weight;
  final double size;
  final bool selectable;
  final bool ignoreColorsIfNull;
  final bool ignoreMaterial;

  static NSText inverted(
    text, {
    lightColor = Colors.black,
    TextDirection textDirection,
    Color color,
    FontWeight weight,
    double size,
    Color darkColor = Colors.white,
    TextAlign textAlign = TextAlign.center,
    ignoreColorsIfNull = false,
    ignoreMaterial = false,
    style = const TextStyle(),
    selectable = false,
    String fontFamily,
  }) {
    return NSText(
      NSLocalizer.numsToFa(text),
      color: color,
      size: size,
      weight: weight,
      lightColor: darkColor,
      textDirection: textDirection,
      darkColor: lightColor,
      textAlign: textAlign,
      style: style,
      selectable: selectable,
      ignoreColorsIfNull: ignoreColorsIfNull,
      fontFamily: fontFamily,
    );
  }

  NSText(this.text,
      {this.color,
      this.size,
      this.weight,
      this.lightColor,
      this.darkColor,
      this.textDirection,
      this.textAlign = TextAlign.center,
      this.style = const TextStyle(),
      this.selectable = false,
      this.ignoreColorsIfNull = false,
      this.ignoreMaterial = false,
      this.fontFamily});

  @override
  Widget build(BuildContext context) {
    final _fontFamily = fontFamily ?? style.fontFamily ?? fontfamily;
    final _color = MediaQuery.of(context).platformBrightness == Brightness.light
        ? color ?? lightColor ?? (ignoreColorsIfNull ? null : Colors.black)
        : color ?? darkColor ?? (ignoreColorsIfNull ? null : Colors.white);

    final sstyle = style.copyWith(
        fontSize: size,
        fontWeight: weight,
        fontFamily: _fontFamily,
        color: _color);

    final theWidget = selectable
        ? SelectableText(
            text,
            style: sstyle,
            textAlign: textAlign,
            textDirection: textDirection,
          )
        : Text(
            text,
            style: sstyle,
            textAlign: textAlign,
            textDirection: textDirection,
          );

    // return theWidget;
    return NSReturnFromRender(context,
        ios: theWidget,
        android: ignoreMaterial
            ? theWidget
            : Material(type: MaterialType.transparency, child: theWidget),
        web: theWidget,
        kDefault: theWidget);
  }
}
