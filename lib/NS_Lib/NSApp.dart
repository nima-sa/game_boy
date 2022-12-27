import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'NSReturnFromRender.dart';

class NSApp extends StatelessWidget {
  static final defaultLightTheme = ThemeData(
      primaryColor: Colors.white,
      primaryColorBrightness: Brightness.light,
      brightness: Brightness.light,
      primaryColorDark: Colors.black,
      canvasColor: Colors.white,
      appBarTheme: AppBarTheme(brightness: Brightness.light));

  static final defaultDarkTheme = ThemeData(
      primaryColor: Colors.black,
      primaryColorBrightness: Brightness.dark,
      primaryColorLight: Colors.black,
      brightness: Brightness.dark,
      primaryColorDark: Colors.black,
      indicatorColor: Colors.white,
      canvasColor: Colors.black,
      // next line is important!
      appBarTheme: AppBarTheme(brightness: Brightness.dark));

  final Widget home;
  final String title;
  final ThemeData theme;
  final ThemeData darkTheme;
  final bool debugShowCheckedModeBanner;

  NSApp(
      {Key key,
      this.home,
      this.title,
      this.debugShowCheckedModeBanner = false,
      this.theme,
      this.darkTheme});

  @override
  Widget build(BuildContext context) {
    StatefulWidget defaultRender = MaterialApp(
      title: title,
      home: home,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      theme: theme,
      darkTheme: darkTheme,
    );

    StatefulWidget ios = CupertinoApp(
      home: home,
      title: title,
      theme: CupertinoThemeData(primaryColor: theme.primaryColor),
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      localizationsDelegates: [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
    );

    return NSReturnFromRender(context,
        ios: ios, android: defaultRender, web: ios, kDefault: ios);

    // try {
    //   if (Platform.isIOS || Platform.isMacOS || kIsWeb) {
    //     return ios;
    //   } else {
    //     return defaultRender;
    //   }
    // } catch (err) {
    //   return kIsWeb ? ios : defaultRender;
    // }
  }
}
