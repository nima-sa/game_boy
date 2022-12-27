import 'package:flutter/material.dart';

enum NSStackDirection { vertical, horizontal, stacked }

// enum _ForMode { width, height }

// class NSStackResponsiveBehaviour {
//   double threshold;
//   NSStackDirection before, after;

//   final _ForMode mode;

//   NSStackResponsiveBehaviour.forWidth(
//       {@required this.threshold, @required before, @required after})
//       : this.mode = _ForMode.width;

//   NSStackResponsiveBehaviour.forHeight(
//       {@required this.threshold, @required before, @required after})
//       : this.mode = _ForMode.height;
// }

class NSStack extends StatelessWidget {
  final NSStackDirection direction;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final StackFit fit;

  NSStack(
      {this.direction = NSStackDirection.vertical,
      @required this.children,
      this.mainAxisAlignment,
      this.mainAxisSize,
      this.fit});

  @override
  Widget build(BuildContext context) {
    switch (this.direction) {
      case NSStackDirection.vertical:
        return Column(
          children: children,
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
        );
      case NSStackDirection.horizontal:
        return Row(
            children: children,
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: mainAxisSize);
      case NSStackDirection.stacked:
        return Stack(
          children: children,
          fit: fit,
        );
    }
    return Container();
  }

  static Widget responsive(
      {@required double threshold,
      @required NSStackDirection before,
      @required NSStackDirection after,
      @required double currentValue,
      @required List<Widget> children,
      MainAxisAlignment mainAxisAlignment,
      MainAxisSize mainAxisSize,
      StackFit fit}) {
    return NSStack(
      direction: currentValue < threshold ? before : after,
      mainAxisSize: mainAxisSize,
      fit: fit,
      mainAxisAlignment: mainAxisAlignment,
      children: children,
    );
  }
}
