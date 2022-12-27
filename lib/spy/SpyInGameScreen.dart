import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_boy/NS_Lib/NSCaptiveText.dart';
import 'package:game_boy/NS_Lib/NSLocalizer.dart';
import 'package:game_boy/NS_Lib/NSScaffold.dart';

import 'package:home_indicator/home_indicator.dart';

import '../handies.dart';
import '../main.dart';

class SpyInGameScreen extends StatefulWidget {
  final String subject;
  final int spyIdx;
  final DateTime endTime;
  const SpyInGameScreen(this.subject, this.spyIdx, this.endTime);

  @override
  _SpyInGameScreenState createState() => _SpyInGameScreenState();
}

class _SpyInGameScreenState extends State<SpyInGameScreen> {
  double opacity = 1;
  List<bool> activeTouches;
  int cheatListIDX = 0;
  bool showingSubject = false;
  @override
  void initState() {
    super.initState();
    activeTouches = List.generate(8, (i) => false);
    if (ccbm)
      Future.delayed(Duration(seconds: 4))
          .then((_) => mounted ? setState(() => opacity = 0) : () {});
    handleTimer();
    HomeIndicator.hide();
  }

  @override
  void dispose() {
    super.dispose();
    HomeIndicator.show();
  }

  void handleTimer() {
    Future.delayed(Duration(seconds: 1)).then((_) {
      if (mounted) setState(() {});
      if (widget.endTime.difference(DateTime.now()).inSeconds > 0) {
        handleTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final elapse = widget.endTime.difference(DateTime.now());
    final timerText = (elapse.inSeconds >= 0
        ? '${twoDigitNum(elapse.inMinutes)}:${twoDigitNum(elapse.inSeconds % 60)}'
        : '00:00');
    return NSScaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _createTouchSection(),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom,
            child: Opacity(
              opacity: showingSubject ? 1 : 0,
              child: NSText(
                NSLocalizer.translate(widget.subject, sub: 'spy'),
                color: Colors.grey[600],
                size: 13,
              ),
            ),
          ),
          Container(
            // color: Colors.black,
            child: Center(
              child: AnimatedOpacity(
                opacity: 1,
                duration: Duration(seconds: 2),
                child: FlatButton(
                  child: NSText(
                    NSLocalizer.numsToLng(
                        '${NSLocalizer.translate('clickHereToReturn')}\n' +
                            timerText),
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

  void handleLongPress(int area) async {
    if (!ccbm) return;
    try {
      if (area == 2) {
        this.setState(() => showingSubject = true);
        final a = MethodChannel("haptic");

        if (area == 1 && cheatListIDX++ == widget.spyIdx)
          await a.invokeMethod('impact_i1');

        Future.delayed(Duration(seconds: 1)).then((value) {
          this.setState(() => showingSubject = false);
        });
      }
    } catch (e) {}
  }

  void handleTap(int area) async {
    if (!ccbm) return;
    try {
      final a = MethodChannel("haptic");

      if (area == 5) {
        cheatListIDX = 0;
        await a.invokeMethod('success');
        return;
      }
      if (cheatListIDX > widget.spyIdx) return;

      if (area == 1 && cheatListIDX++ == widget.spyIdx) {
        await a.invokeMethod('impact_i1');
        // print('vibrating');
      }
    } catch (e) {}
  }

  Widget _createGestureDetector(int area) {
    return Expanded(
      child: GestureDetector(
        onTapCancel: () => setState(() => activeTouches[area] = false),
        onTapUp: (e) => setState(() => activeTouches[area] = true),
        onTapDown: (e) => setState(() => activeTouches[area] = false),
        onLongPress: () => handleLongPress(area),
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
