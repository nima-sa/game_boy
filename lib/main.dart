import 'package:flutter/material.dart';
import 'package:game_boy/NS_Lib/NSMaterializedColors.dart';

import 'NS_Lib/NSApp.dart';
import 'NS_Lib/NSReturnFromRender.dart';
import 'RootScreen.dart';

// import 'Apploclizations.dart';

final bool ccbm = true;
void main() {
  kRenderType = RenderType.android;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NSApp(
      title: 'Game boy',
      // supportedLocales: [
      //   Locale('en'),
      //   Locale('fa'),
      // ],
      // localizationsDelegates: [
      //   AppLocalizations.delegate,
      // GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate
      // ],
      // localeResolutionCallback: (locale, supportedLocales) {
      //   for (var supportedLocale in supportedLocales) {
      //     if (supportedLocale.languageCode == locale.languageCode &&
      //         supportedLocale.countryCode == locale.countryCode) {
      //       return supportedLocale;
      //     }
      //   }
      //   return supportedLocales.first;
      // },

      theme: ThemeData(
        primarySwatch: NSMaterializedColors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      darkTheme: ThemeData.dark().copyWith(
        primaryColor: NSMaterializedColors.black,
      ),
      home: Root(),
    );
  }
}
