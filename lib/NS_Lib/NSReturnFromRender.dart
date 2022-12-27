import 'dart:io';

import 'package:flutter/material.dart';

enum RenderType { iOS, android, auto }

RenderType kRenderType;

// ignore: non_constant_identifier_names
T NSReturnFromRender<T>(BuildContext context,
    {T ios, T android, T web, T kDefault, RenderType renderType}) {
  switch (renderType ?? kRenderType) {
    case RenderType.iOS:
      return ios;

    case RenderType.android:
      return android;

    case RenderType.auto:
    default:
      try {
        if (Platform.isIOS || Platform.isMacOS) {
          return ios;
        } else {
          return android;
        }
      } catch (err) {
        return android;
      }
  }
}
