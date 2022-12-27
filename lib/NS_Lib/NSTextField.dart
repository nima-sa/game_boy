import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'NSReturnFromRender.dart';

class NSTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeHolder;
  final TextInputType keyboardType;
  final bool autofocus;
  NSTextField(
      {this.controller, this.placeHolder, this.keyboardType, this.autofocus});

  @override
  Widget build(BuildContext context) {
    final ios = CupertinoTextField(
      controller: controller,
      placeholder: placeHolder,
      keyboardType: keyboardType,
      autofocus: autofocus,
    );
    final android = TextField(
      controller: controller,
      keyboardType: keyboardType,
      autofocus: autofocus,
      decoration: InputDecoration(hintText: placeHolder),
    );
    return NSReturnFromRender(context,
        ios: ios, android: android, web: ios, kDefault: ios);
  }
}
