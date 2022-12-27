import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NSAppBar {
  final Widget title;
  final List<Widget> leadingButtons;
  final List<Widget> trailingButtons;
  final String backButtonTitle;
  final Color iOSItemsColor;
  final Color iOSLightItemsColor;
  final Color iOSDarkItemsColor;

  final Color backgroundColor;

  NSAppBar(
      {Key key,
      this.title,
      this.leadingButtons,
      this.trailingButtons,
      this.iOSItemsColor,
      this.backButtonTitle,
      this.backgroundColor,
      this.iOSLightItemsColor,
      this.iOSDarkItemsColor});

  CupertinoNavigationBar forIOS(BuildContext context) {
    // final _color = MediaQuery.of(context).platformBrightness == Brightness.light
    //     ? iOSLightItemsColor ?? iOSItemsColor
    //     : iOSDarkItemsColor ?? iOSItemsColor;
    return CupertinoNavigationBar(
      backgroundColor: backgroundColor,
      middle: title,
      // actionsForegroundColor: _color ?? Colors.blue,
      leading: leadingButtons != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: leadingButtons,
            )
          : null,
      trailing: trailingButtons != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: trailingButtons,
            )
          : null,
      previousPageTitle: backButtonTitle,
    );
  }

  AppBar forAndroid() {
    final leading = leadingButtons != null && leadingButtons.length > 0
        ? leadingButtons[0]
        : null;
    final List<Widget> etc = leadingButtons != null && leadingButtons.length > 1
        ? leadingButtons.sublist(1)
        : [];
    final List<Widget> actions =
        etc + (trailingButtons != null ? trailingButtons : []);

    return AppBar(
      backgroundColor: backgroundColor,
      title: title,
      leading: leading,
      centerTitle: true,
      actions: actions,
    );
  }
}
