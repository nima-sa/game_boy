import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'NSReturnFromRender.dart';

class NSAlertButton extends StatelessWidget {
  final Widget child;
  // final bool enabled;
  final bool isDefaultAction;
  final bool isDestructiveAction;
  final VoidCallback onPressed;
  final VoidCallback onLongPress;

  NSAlertButton(
      {this.child,
      // this.enabled,
      this.isDefaultAction = true,
      this.isDestructiveAction = false,
      this.onPressed,
      this.onLongPress});

  @override
  Widget build(BuildContext context) {
    StatelessWidget ios = CupertinoDialogAction(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: child,
      ),
      isDefaultAction: isDefaultAction,
      isDestructiveAction: isDestructiveAction,
      onPressed: () {
        Navigator.pop(context);
        this.onPressed();
      },
    );

    StatelessWidget android = FlatButton(
      child: child,
      onPressed: () {
        Navigator.pop(context);
        this.onPressed();
      },
      onLongPress: onLongPress,
    );
    return NSReturnFromRender(context,
        ios: ios, android: android, web: ios, kDefault: ios);
  }
}
