import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_boy/NS_Lib/NSCaptiveText.dart';
import 'package:game_boy/NS_Lib/NSLocalizer.dart';
import 'package:game_boy/NS_Lib/NSScaffold.dart';
import 'package:game_boy/main.dart';

// import 'package:home_indicator/home_indicator.dart';

import 'MafiaRole.dart';

class MafiaInGameScreen extends StatefulWidget {
  final List<MafiaRoleHolder> roles;

  MafiaInGameScreen(this.roles);
  @override
  _MafiaInGameScreenState createState() => _MafiaInGameScreenState();
}

class _MafiaInGameScreenState extends State<MafiaInGameScreen> {
  double opacity = 1;
  List<bool> activeTouches;
  var cheatListIDX = 0;

  @override
  void initState() {
    super.initState();
    activeTouches = List.generate(8, (i) => false);
    if (ccbm)
      Future.delayed(Duration(seconds: 4))
          .then((value) => setState(() => opacity = 0));

    // HomeIndicator.hide();
  }

  @override
  void dispose() {
    super.dispose();
    // HomeIndicator.show();
  }

  @override
  Widget build(BuildContext context) {
    return NSScaffold(
      body:
          // Center(child: NSText('nima'))

          Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _createTouchSection(),
          Container(
            // color: Colors.black,
            child: Center(
              child: AnimatedOpacity(
                opacity: opacity,
                duration: Duration(seconds: 2),
                child: TextButton(
                  child: NSText(
                    NSLocalizer.translate('clickHereToReturn'),
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handleTap(int area) async {
    if (!ccbm) return;
    try {
      final a = MethodChannel("haptic");
      if (area == 5) {
        cheatListIDX = 0;
        await a.invokeMethod("success");
        return;
      }
      if (cheatListIDX >= widget.roles.length) return;
      final role = widget.roles[cheatListIDX++];

      if (area == 1) {
        // if (activeTouches[0] && activeTouches[2] && activeTouches[4]) {
        if (role.role == Role.godFather) {
          await a.invokeMethod("error");
        } else if (role.role == Role.natasha) {
          await a.invokeMethod("success");
        } else if (role.kClass == RoleClass.bad) {
          await a.invokeMethod('impact_i1');
        }
      } else if (area == 2) {
        if (role.role == Role.inspector) {
          await a.invokeMethod("error");
        } else if (role.role == Role.doctor) {
          await a.invokeMethod("success");
        } else if (role.role == Role.priest) {
          await a.invokeMethod('impact_i1');
        }
      }
    } catch (e) {}
  }

  Widget _createGestureDetector(int area) {
    return Expanded(
      child: GestureDetector(
        onTapCancel: () => setState(() => activeTouches[area] = false),
        onTapUp: (e) => setState(() => activeTouches[area] = true),
        onTapDown: (e) => setState(() => activeTouches[area] = false),
        onTap: () => handleTap(area),
        behavior: HitTestBehavior.translucent,
        child: Container(
            // color: _colors[area],
            // child: Center(child: NSText('$area')),
            ),
      ),
    );
  }

  Widget _createGestureDetectorRow(int a1, int a2) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _createGestureDetector(a1),
          _createGestureDetector(a2),
        ],
      ),
    );
  }

  // final _colors = [
  //   Colors.red,
  //   Colors.blue,
  //   Colors.green,
  //   Colors.yellow,
  //   Colors.amber,
  //   Colors.purple,
  //   Colors.teal,
  //   Colors.brown,
  //   Colors.deepOrange,
  //   Colors.lightBlueAccent
  // ];

  Widget _createTouchSection() {
    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _createGestureDetectorRow(0, 1),
          _createGestureDetectorRow(2, 3),
          _createGestureDetectorRow(4, 5),
          // _createGestureDetectorRow(6, 7),
        ],
      ),
    );
  }
}
