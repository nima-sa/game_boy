import 'package:flutter/material.dart';
import 'package:game_boy/NS_Lib/NSTouchableBouncer.dart';
import 'package:game_boy/spy/SpyCategoryScreen.dart';
import 'package:game_boy/truthOrDare/TruthOrDareMainScreen.dart';
import 'Mafia/MafiaMainScreen.dart';
import 'NS_Lib/NSCaptiveText.dart';
import 'NS_Lib/NSColor.dart';
import 'NS_Lib/NSLocalizer.dart';
import 'NS_Lib/NSAppBar.dart';
import 'NS_Lib/NSMaterializedColors.dart';
import 'NS_Lib/NSTouchableOpacity.dart';
import 'NS_Lib/NSImage.dart';
import 'NS_Lib/NSScaffold.dart';

class GameSelectionScreen extends StatelessWidget {
  final VoidCallback onLanguageSelected;
  GameSelectionScreen({this.onLanguageSelected});

  void pushScreen(BuildContext context, String name) {
    if (name == 'mafia')
      NSScaffold.pushScreen(context, MafiaMainScreen());
    else if (name == 'spy')
      NSScaffold.pushScreen(context, SpyCategoryScreen());
    else if (name == 'truthOrDare')
      NSScaffold.pushScreen(context, TruthOrDareMainScreen());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: NSLocalizer.load('lang'),
      builder: (BuildContext context, AsyncSnapshot<Map<String, String>> ss) {
        final ssData = ss.data ?? {};
        final size = MediaQuery.of(context).size;
        final buttonSize = size.width / 2 - 24;
        return NSScaffold(
          darkBackgroundColor:
              NSColor.platform(iOS: Colors.black, android: Colors.grey[850]),
          navBar: NSAppBar(
            backgroundColor: NSColor.dynamic(
              light: Colors.white,
              dark: NSMaterializedColors.black,
            ),
            title: NScaptiveTextNavBar(
              ssData['chooseGame'] ?? '',
              lightColor: Colors.black,
            ),
            // trailingButtons: [
            //   NSIconButton(
            //     padding: EdgeInsets.all(0),
            //     icon: NSIcon(Icons.language),
            //     onPressed: onLanguageSelected,
            //     darkIconColor: Colors.white,
            //     lightIconColor: Colors.black,
            //   )
            // ],
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: LayoutBuilder(
                builder: (_, cc) => Container(
                  height: cc.maxHeight,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            NSTouchableBouncer(
                              child: NSTouchableOpacity(
                                darkColor: Colors.blueGrey[500],
                                lightColor: Colors.blueGrey[300],
                                // color: Colors.grey[300],
                                onPress: () =>
                                    this.pushScreen(context, 'mafia'),
                                width: buttonSize,
                                height: buttonSize,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image(
                                          image: AssetImage(
                                              'assets/images/mafia.png'),
                                        ),
                                      ),
                                    ),
                                    NSText(ssData['mafia'] ??
                                        ''), //, color: Colors.black),
                                    SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ),
                            NSTouchableBouncer(
                              child: NSTouchableOpacity(
                                darkColor: Colors.blueGrey[500],
                                lightColor: Colors.blueGrey[300],
                                // color: Colors.grey[300],
                                onPress: () => this.pushScreen(context, 'spy'),
                                width: buttonSize,
                                height: buttonSize,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: NSImage(
                                          image: AssetImage(
                                              'assets/images/spy.png'),
                                        ),
                                      ),
                                    ),
                                    NSText(ssData['spy'] ??
                                        ''), // color: Colors.black),
                                    SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            NSTouchableBouncer(
                              child: NSTouchableOpacity(
                                darkColor: Colors.blueGrey[500],
                                lightColor: Colors.blueGrey[300],
                                // color: Colors.grey[300],
                                onPress: () =>
                                    this.pushScreen(context, 'truthOrDare'),
                                width: buttonSize,
                                height: buttonSize,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: NSImage(
                                          image: AssetImage(
                                              'assets/images/bottle.png'),
                                        ),
                                      ),
                                    ),
                                    NSText(ssData['truthOrDare'] ??
                                        ''), // color: Colors.black),
                                    SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
