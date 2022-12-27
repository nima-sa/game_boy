
import 'package:flutter/material.dart';

class NSMaterializedColors  {
  static MaterialColor get black {
    final k = 0;
    final Map<int, Color> _map = {
    50:  Color.fromRGBO(k, k, k, 0.1),
    100: Color.fromRGBO(k, k, k, 0.2),
    200: Color.fromRGBO(k, k, k, 0.3),
    300: Color.fromRGBO(k, k, k, 0.4),
    400: Color.fromRGBO(k, k, k, 0.5),
    500: Color.fromRGBO(k, k, k, 0.6),
    600: Color.fromRGBO(k, k, k, 0.7),
    700: Color.fromRGBO(k, k, k, 0.8),
    800: Color.fromRGBO(k, k, k, 0.9),
    900: Color.fromRGBO(k, k, k, 1.0),
  };
    return MaterialColor(0xFF000000 , _map);
  }


  static MaterialColor get white {
    final int k = 220;
    final Map<int, Color> _map = {
    50:  Color.fromRGBO(k, k, k, 0.1),
    100: Color.fromRGBO(k, k, k, 0.2),
    200: Color.fromRGBO(k, k, k, 0.3),
    300: Color.fromRGBO(k, k, k, 0.4),
    400: Color.fromRGBO(k, k, k, 0.5),
    500: Color.fromRGBO(k, k, k, 0.6),
    600: Color.fromRGBO(k, k, k, 0.7),
    700: Color.fromRGBO(k, k, k, 0.8),
    800: Color.fromRGBO(k, k, k, 0.9),
    900: Color.fromRGBO(k, k, k, 1.0),
  };

    return MaterialColor(0xFFDDDDDD , _map);
  }

}