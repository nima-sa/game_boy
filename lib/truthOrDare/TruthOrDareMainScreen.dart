import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:game_boy/NS_Lib/NSAppBar.dart';
import 'package:game_boy/NS_Lib/NSCaptiveText.dart';
import 'package:game_boy/NS_Lib/NSColor.dart';
import 'package:game_boy/NS_Lib/NSLocalizer.dart';
import 'package:game_boy/NS_Lib/NSMaterializedColors.dart';
import 'package:game_boy/NS_Lib/NSScaffold.dart';

extension GlobalKeyExtension on GlobalKey {
  Rect get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null)?.getTranslation();
    if (translation != null && renderObject.paintBounds != null) {
      return renderObject.paintBounds
          .shift(Offset(translation.x, translation.y));
    } else {
      return null;
    }
  }
}

class TruthOrDareMainScreen extends StatefulWidget {
  @override
  _TruthOrDareMainScreenState createState() => _TruthOrDareMainScreenState();
}

class _TruthOrDareMainScreenState extends State<TruthOrDareMainScreen>
    with SingleTickerProviderStateMixin {
  AnimationController ctrl;
  GlobalKey bottleKey = GlobalKey();
  bool isInUpperPartOfTheBottle = false;
  bool isInRighterPartOfTheBottle = false;
  @override
  void initState() {
    super.initState();
    ctrl = AnimationController.unbounded(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 2;
    return GestureDetector(
      onPanUpdate: (d) {
        final Offset bottleCenter = bottleKey.globalPaintBounds.center;
        double valY = 0;
        double valX = 0;

        if (bottleCenter != null) {
          if (d.globalPosition.dy > bottleCenter.dy) {
            valY = -d.delta.dx / 100;
            isInUpperPartOfTheBottle = true;
          } else {
            valY = d.delta.dx / 100;
            isInUpperPartOfTheBottle = false;
          }

          if (d.globalPosition.dx > bottleCenter.dx) {
            valX = d.delta.dy / 100;
            isInRighterPartOfTheBottle = true;
          } else {
            valX = -d.delta.dy / 100;
            isInRighterPartOfTheBottle = false;
          }
        } else {
          valY = d.delta.dx / 100;
        }

        ctrl.value += valY + valX;
      },
      onPanEnd: (d) {
        ctrl.animateWith(
          FrictionSimulation(
              0.1, // <- the bigger this value, the less friction is applied
              ctrl.value,
              (d.velocity.pixelsPerSecond.dx /
                      100 *
                      (isInUpperPartOfTheBottle ? -1 : 1)) +
                  (d.velocity.pixelsPerSecond.dy /
                      100 *
                      (isInRighterPartOfTheBottle
                          ? 1
                          : -1)) // <- Velocity of inertia
              ),
        );
      },
      child: NSScaffold(
        darkBackgroundColor: Colors.grey[700],
        navBar: NSAppBar(
          title: SizedBox(
            width: 120,
            child: NScaptiveTextNavBar(
              NSLocalizer.translate('truthOrDare'),
              lightColor: Colors.black,
            ),
          ),
          iOSDarkItemsColor: Colors.white,
          iOSLightItemsColor: Colors.black,
          backgroundColor: NSColor.dynamic(
            light: Colors.white,
            dark: NSMaterializedColors.black,
          ),
        ),
        body: AnimatedBuilder(
          key: bottleKey,
          animation: ctrl,
          // child: Container(width: 100, height: 100, color: Colors.blue),
          child: Image.asset(
            'assets/images/wine-bottle.png',
            width: width,
            // height: 480,
          ),
          builder: (ctx, w) {
            return Center(
              child: Transform.rotate(
                angle: ctrl.value,
                child: w,
              ),
            );
          },
        ),
      ),
    );
  }
}
