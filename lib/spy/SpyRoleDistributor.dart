import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:game_boy/NS_Lib/NSCaptiveText.dart';
import 'package:game_boy/NS_Lib/NSColor.dart';
import 'package:game_boy/NS_Lib/NSIconButton.dart';
import 'package:game_boy/NS_Lib/NSLocalizer.dart';
import 'package:game_boy/NS_Lib/NSAppBar.dart';
import 'package:game_boy/NS_Lib/NSMaterializedColors.dart';
import 'package:game_boy/NS_Lib/NSScaffold.dart';
import 'package:game_boy/NS_Lib/NSStorage.dart';

import 'SpyInGameScreen.dart';

class SpyRoleDistributer extends StatefulWidget {
  final int players;
  final List<String> subCaterogies;

  SpyRoleDistributer(this.players, this.subCaterogies);

  @override
  _SpyRoleDistributerState createState() => _SpyRoleDistributerState();
}

class _SpyRoleDistributerState extends State<SpyRoleDistributer>
    with SingleTickerProviderStateMixin {
  bool isShowingRole = false;
  int currentPerson = -1;
  String subject;
  int spy;
  Map<String, dynamic> reps = {};
  bool hasIncreased = false;
  int spyIDX = -1;
  // List<bool> roles = [];
  DateTime endTime;
  @override
  void initState() {
    super.initState();
    // roles = List.generate(widget.players - 1, (_) => true) + [false];

    randomizeEverything();
  }

  void randomizeEverything([bool resume = false]) {
    reps = json.decode(NSStorage.recallCached(key: 'spyreps') ?? '{}');
    // reps = {'a': 100, 'b': 10, 'c': 0};

    List<String> subjects = List.from(widget.subCaterogies);
    // List<String> subjects = ['a', 'b', 'c'];
    subjects.shuffle();
    subjects.sort((a, b) {
      final _a = reps[a] ?? 0;
      final _b = reps[b] ?? 0;
      return _a - _b;
    });
    while (subjects.length >= 2 &&
        (reps[subjects[0]] ?? 0) != (reps[subjects.last] ?? 0))
      subjects.removeLast();

    final objIdx = Random(DateTime.now().millisecond).nextInt(subjects.length);
    // spy = Random(DateTime.now().millisecond).nextInt(widget.players);

    subject = subjects[objIdx];
    currentPerson = resume ? 0 : -1;
    isShowingRole = resume;
    hasIncreased = false;
    // roles = List.generate(widget.players - 1, (_) => true) + [false];

    // roles.shuffle();
    int tmpSpy = Random().nextInt(widget.players);
    while (tmpSpy == spy) tmpSpy = Random().nextInt(widget.players);
    spy = tmpSpy; //roles.indexOf(false);
    endTime = null;
    // incKey(subject);
  }

  @override
  Widget build(BuildContext context) {
    String text = '';
    String buttonText = NSLocalizer.translate('showSubject', sub: 'spy');
    String hintText =
        NSLocalizer.translate('pressShowRoleWhenYouWereReady', sub: 'spy');
    String iconPath = 'pass-phone-to-other';

    if (isShowingRole) {
      if (currentPerson == spy) {
        text = NSLocalizer.translate('youAreSpy', sub: 'spy');
      } else {
        text = NSLocalizer.translate(subject, sub: 'spy');
      }
      hintText = '';
      buttonText = NSLocalizer.translate('ok');
    } else {
      if (currentPerson >= widget.players - 1) {
        buttonText = NSLocalizer.translate('startGame');
        currentPerson++; // to trigger buttons behaivour
        iconPath = 'start';
        text = '';
        hintText = '';
      } else {
        text = currentPerson == -1
            ? NSLocalizer.translate('passToFirstPlayer', sub: 'spy')
            : NSLocalizer.translate('passToNextPlayer', sub: 'spy');
      }
    }
    return NSScaffold(
      darkBackgroundColor:
          NSColor.platform(iOS: Colors.black, android: Colors.grey[850]),
      navBar: NSAppBar(
          title: NScaptiveTextNavBar(
            NSLocalizer.translate('selectRoles'),
            lightColor: Colors.black,
          ),
          iOSLightItemsColor: Colors.black,
          iOSDarkItemsColor: Colors.white,
          backgroundColor: NSColor.dynamic(
            light: Colors.white,
            dark: NSMaterializedColors.black,
          ),
          trailingButtons: [
            if (currentPerson >= 0)
              NSIconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.replay,
                  color: NSColor(light: 0xFF000000, dark: 0xFFFFFFFF),
                ),
                onLongPress: () {
                  if (currentPerson != spy) incKey(subject);
                },
                onPressed: () {
                  randomizeEverything(true);
                  setState(() {});
                },
              )
          ]),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 240,
                      child: CircleAvatar(
                        backgroundColor: Colors.blueGrey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset('assets/spy/$iconPath.png'),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        // color: MediaQuery.of(context).platformBrightness ==
                        //         Brightness.light
                        //     ? Colors.blueGrey
                        //     : Colors.blueGrey,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: NSText(
                          text,
                          size: 20,
                          weight: FontWeight.bold,
                          color: Colors.amber,
                          // lightColor: Colors.blueGrey,
                          // darkColor: Colors.amber,
                          textDirection: NSLocalizer.textDirection,
                        ),
                      ),
                    ),
                    Spacer(),
                    Column(
                      children: [
                        NSText(
                          hintText,
                          weight: FontWeight.normal,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        // NSRaisedButton(
                        //   body: NSText(buttonText),
                        //   // padding: EdgeInsets.symmetric(horizontal: 0),
                        //   onPressed: () {
                        //     this.isShowingRole = !this.isShowingRole;
                        //     if (this.isShowingRole) currentPerson++;
                        //     setState(() {});
                        //   },
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (currentPerson >= widget.players)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.all(8),
                              backgroundColor: Colors.blue,
                            ),
                            child: NSText(
                              NSLocalizer.translate('viewSpy', sub: 'spy'),
                              color: Colors.white,
                            ),
                            onPressed: () {},
                            onLongPress: () {
                              NSScaffold.showAlert(
                                context,
                                message: NSText(
                                  NSLocalizer.numsToLng(
                                    NSLocalizer.translate(
                                          'nthPerson',
                                          sub: 'spy',
                                        ) +
                                        ' ${spy + 1}\n${NSLocalizer.translate(subject, sub: 'spy')}',
                                  ),
                                ),
                                dismissTitle: NSLocalizer.translate('ok'),
                              );
                              // print('hi');
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.replay),
                          onPressed: () {
                            incKey(subject);
                            randomizeEverything();
                            currentPerson = -1;
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),

                // NSButton(
                //   color: Colors.amber,
                //   padding: EdgeInsets.zero,
                //   body: NSText(
                //     NSLocalizer.translate('again'),
                //     size: 14,
                //     color: Colors.black,
                //   ),
                //   onPressed: () {
                //     randomizeEverything();
                //     currentPerson = -1;
                //     setState(() {});
                //   },
                // ),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                MediaQuery.of(context).platformBrightness ==
                                        Brightness.light
                                    ? Colors.white
                                    : Colors.white,
                            backgroundColor:
                                MediaQuery.of(context).platformBrightness ==
                                        Brightness.light
                                    ? Colors.blueGrey
                                    : Colors.blueGrey,
                            padding: EdgeInsets.fromLTRB(8, 8, 8,
                                MediaQuery.of(context).padding.bottom + 8),
                          ),
                          child: NSText(
                            buttonText,
                            size: 20,
                            color: Colors.white,
                            weight: FontWeight.bold,
                          ),
                          onPressed: () {
                            if (currentPerson >= widget.players - 1)
                              incKey(subject);

                            if (currentPerson >= widget.players) {
                              endTime ??= DateTime.now()
                                  .add(Duration(minutes: widget.players));
                              print(endTime);
                              NSScaffold.pushScreen(context,
                                  SpyInGameScreen(subject, spy, endTime));
                            } else {
                              this.isShowingRole = !this.isShowingRole;
                              if (this.isShowingRole) currentPerson++;
                              setState(() {});
                            }
                          }),
                    ),
                    // RaisedButton(
                    //   color: Colors.amber,
                    //   padding: EdgeInsets.fromLTRB(
                    //       8, 8, 8, MediaQuery.of(context).padding.bottom + 8),
                    //   child: NSText(
                    //     NSLocalizer.translate('again'),
                    //     size: 14,
                    //     color: Colors.black,
                    //   ),
                    //   onPressed: () {
                    //     randomizeEverything();
                    //     currentPerson = -1;
                    //     setState(() {});
                    //   },
                    // ),
                    // if (currentPerson >= widget.players)
                    //   Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: FloatingActionButton(
                    //       child: Icon(Icons.replay),
                    //       onPressed: () {
                    //         incKey(subject);
                    //         randomizeEverything();
                    //         currentPerson = -1;
                    //         setState(() {});
                    //       },
                    //     ),
                    //   ),
                    // if (currentPerson > -1)
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.replay),
      //   onPressed: () {
      //     randomizeEverything();
      //     currentPerson = -1;
      //     setState(() {});
      //   },
      // ),
    );
  }

  void incKey(String key) {
    if (hasIncreased) return;
    reps[key] = (reps[key] ?? 0) + 1;
    final val = json.encode(reps);
    NSStorage.memorise(key: 'spyreps', value: val);
    hasIncreased = true;
  }
}
