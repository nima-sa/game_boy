import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'NSAlertbutton.dart';
import 'NSReturnFromRender.dart';

enum AlertStyle { alert, actionSheet }

class NSAlert extends StatelessWidget {
  final Widget title;
  final Widget message;
  final List<Widget> actions;
  final String dismissTitle;
  final AlertStyle style;

  NSAlert(
      {this.title,
      this.message,
      this.actions,
      this.dismissTitle = 'Dismiss',
      this.style = AlertStyle.alert});

  @override
  Widget build(BuildContext context) {
    List<Widget> dismiss = dismissTitle != null
        ? <Widget>[NSAlertButton(child: Text(dismissTitle), onPressed: () {})]
        : [];

    List<Widget> _actions = (actions ?? <Widget>[]) + dismiss;
    StatelessWidget ios;
    StatelessWidget android;

    if (style == AlertStyle.actionSheet) {
      ios = CupertinoActionSheet(
        title: title,
        message: message,
        actions: actions,
        cancelButton: NSAlertButton(
          child: Text(dismissTitle),
          onPressed: () {
            // Navigator.of(context).pop();
          },
        ),
      );
    } else {
      ios = CupertinoAlertDialog(
        title: title,
        content: message,
        actions: _actions,
      );
    }

    if (style == AlertStyle.actionSheet) {
      android = SimpleDialog(
        title: title,
        children: _actions,
      );
    } else {
      android = AlertDialog(
        title: title,
        content: message,
        actions: _actions,
      );
    }
    return NSReturnFromRender(context,
        ios: ios, android: android, web: ios, kDefault: ios);
  }
}
