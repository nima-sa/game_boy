import 'package:flutter/material.dart';
import 'NSReturnFromRender.dart';

class NSTouchableOpacity extends StatefulWidget {
  final Widget child;
  final VoidCallback onPress;
  final VoidCallback onLongPress;
  final double width;
  final double height;
  final Color color;
  final Color lightColor;
  final Color darkColor;
  final double cornerRadius;

  NSTouchableOpacity(
      {@required this.child,
      @required this.onPress,
      this.onLongPress,
      this.width,
      this.height,
      this.color,
      this.lightColor,
      this.darkColor,
      this.cornerRadius = 8});

  @override
  _NSTouchableOpacityState createState() => _NSTouchableOpacityState();
}

class _NSTouchableOpacityState extends State<NSTouchableOpacity> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    final iosPressColor =
        MediaQuery.of(context).platformBrightness == Brightness.light
            ? Color(0x55FFFFFF)
            : Color(0x55000000);

    final _color = MediaQuery.of(context).platformBrightness == Brightness.light
        ? widget.lightColor ?? widget.color
        : widget.darkColor ?? widget.color;

    final ios = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onPress,
      onLongPress: widget.onLongPress,
      onTapDown: (e) => setState(() => pressed = true),
      onTapCancel: () => setState(() => pressed = false),
      onTapUp: (e) => setState(() => pressed = false),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.cornerRadius),
        child: Container(
          height: widget.height,
          width: widget.width,
          color: _color,
          child: Stack(
            children: <Widget>[
              Center(child: widget.child),
              AnimatedOpacity(
                duration: Duration(milliseconds: 50),
                child: Container(
                  color: pressed ? iosPressColor : Color(0x0000),
                ),
                opacity: pressed ? 1 : 0,
              ),
            ],
          ),
        ),
      ),
    );

    final android = ClipRRect(
      borderRadius: BorderRadius.circular(widget.cornerRadius),
      child: Container(
        height: widget.height,
        width: widget.width,
        child: Material(
          color: _color,
          child: InkWell(
            borderRadius: BorderRadius.circular(widget.cornerRadius),
            child: widget.child,
            onLongPress: widget.onLongPress,
            onTap: widget.onPress,
          ),
        ),
      ),
    );

    return NSReturnFromRender(context,
        ios: ios, android: android, web: ios, kDefault: ios);
  }
}
