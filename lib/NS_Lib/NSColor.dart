import 'package:flutter/material.dart';
import 'package:game_boy/NS_Lib/NSReturnFromRender.dart';

// Every method in this class should be called in a Widget that re-renders when setState is called. Otherwise changes would not apply
class NSColor extends Color {
  NSColor({int light, int dark})
      : super(
          MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                      .platformBrightness ==
                  Brightness.light
              ? light
              : dark,
        );

  NSColor.fromColor({Color light, Color dark})
      : super(
          MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                      .platformBrightness ==
                  Brightness.light
              ? light.value
              : dark.value,
        );

  NSColor.fromRGBO(
      int lr, int lg, int lb, double lo, int dr, int dg, int db, double _do)
      : super(MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                    .platformBrightness ==
                Brightness.light
            ? Color.fromRGBO(lr, lg, lb, lo).value
            : Color.fromRGBO(dr, dg, db, _do).value);

  static Color dynamic({@required Color light, @required Color dark}) {
    final brightness = MediaQueryData.fromWindow(WidgetsBinding.instance.window)
        .platformBrightness;

    return brightness == Brightness.light ? light : dark;
  }

  static Color platform({Color iOS, Color android, RenderType force}) {
    return NSReturnFromRender(null,
        ios: iOS, android: android, web: iOS, kDefault: iOS, renderType: force);
  }
}
