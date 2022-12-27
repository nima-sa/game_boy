import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'NSAlert.dart';
import 'NSAppBar.dart';
import 'NSPageRoute.dart';
import 'NSReturnFromRender.dart';

class NSScaffold extends StatelessWidget {
  final Widget body;
  final NSAppBar navBar;
  final Widget floatingActionButton;
  final Color backgroundColor;
  final Color lightBackgroundColor;
  final Color darkBackgroundColor;

  static Color background;
  static Color lightBackground;
  static Color darkBackground;

  NSScaffold({
    Key key,
    this.body,
    this.navBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.lightBackgroundColor,
    this.darkBackgroundColor,
  });

  static Future<T> showAlert<T>(BuildContext context,
      {Widget title,
      Widget message,
      List<Widget> actions,
      String dismissTitle = 'Dismiss',
      AlertStyle style = AlertStyle.alert}) async {
    final alert = NSAlert(
        title: title,
        message: message,
        actions: actions,
        dismissTitle: dismissTitle,
        style: style);

    try {
      if (Platform.isIOS || Platform.isMacOS) {
        if (style == AlertStyle.actionSheet) {
          return showCupertinoModalPopup(
              context: context, builder: (context) => alert);
        } else {
          return showCupertinoDialog(
              context: context, builder: (context) => alert);
        }
      } else {
        return showDialog(context: context, builder: (context) => alert);
      }
    } catch (err) {
      return showDialog(context: context, builder: (context) => alert);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color _color = backgroundColor ??
        NSScaffold.background ??
        (MediaQuery.of(context).platformBrightness == Brightness.light
            ? (lightBackgroundColor ?? NSScaffold.lightBackground)
            : (darkBackgroundColor ?? NSScaffold.darkBackground));
    // final EdgeInsets safeAreaPadding = MediaQuery.of(context).padding;
    Widget iosBody = floatingActionButton != null
        ? Stack(
            fit: StackFit.expand,
            children: <Widget>[
              // Expanded(child: body),
              body,
              Positioned(
                child: floatingActionButton,
                bottom: 16,
                right: 16,
              )
            ],
          )
        : body;

    StatefulWidget ios = CupertinoPageScaffold(
      backgroundColor: _color,
      child: iosBody,
      navigationBar: navBar != null ? navBar.forIOS(context) : null,
    );

    StatefulWidget android = Scaffold(
        backgroundColor: _color,
        appBar: navBar != null ? navBar.forAndroid() : null,
        body: body,
        floatingActionButton: floatingActionButton);

    return NSReturnFromRender(context,
        ios: ios, android: android, web: ios, kDefault: ios);
  }

  static void toast(BuildContext context, Widget content,
      {Duration duration = const Duration(seconds: 2),
      Color androidBackgroundColor}) {
    try {
      if (Platform.isIOS || Platform.isMacOS) {
        Timer(duration, () {
          Navigator.pop(context);
        });
        showAlert(
          context,
          title: content,
          dismissTitle: null,
        );
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: content,
          duration: duration,
        ));
      }
    } catch (err) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: content,
        backgroundColor: androidBackgroundColor,
        duration: duration,
      ));
    }
  }

  static Future<T> pushScreen<T extends Object>(
      BuildContext context, Widget screen) async {
    final result = await Navigator.push(
        context, NSPageRoute<T>(builder: (context) => screen));
    return result;
  }
}
