import 'package:flutter/material.dart';
import 'package:game_boy/MySplashScreen.dart';
import 'NS_Lib/NSAlertbutton.dart';
import 'NS_Lib/NSStorage.dart';
import 'NS_Lib/NSLocalizer.dart';

import 'GameSelectionScreen.dart';
import 'NS_Lib/NSMaterializedColors.dart';
import 'NS_Lib/NSCaptiveText.dart';
import 'NS_Lib/NSRaisedButton.dart';
import 'NS_Lib/NSScaffold.dart';

class Root extends StatefulWidget {
  final bool willApplyNextTime;
  final VoidCallback callback;
  Root({this.willApplyNextTime = false, this.callback});
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  String applng;
  bool splashShown = false;

  void _setLanguage(String isoCode) async {
    await NSStorage.memorise(key: 'applng', value: isoCode);
    NSLocalizer.clearCache();

    if (widget.willApplyNextTime) {
      NSScaffold.showAlert(
        context,
        title: NSCaptiveTextAlertTitle(
            NSLocalizer.translate('changesWillApplyNextTime')),
        actions: [
          NSAlertButton(
            child: Text(
              NSLocalizer.translate('ok'),
            ),
            onPressed: widget.callback ?? pushNext,
          ),
        ],
        dismissTitle: null,
      );
    } else {
      pushNext(isoCode);
    }
  }

  void pushNext(String applng) {
    setState(() => this.applng = applng);

    // NSScaffold.pushScreen(context, GameSelectionScreen());
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1))
        .then((value) => setState(() => splashShown = true));
    // HomeIndicator.hide();
  }

  Future<String> _loadLngs() async {
    await NSStorage.memorise(key: 'applng', value: 'fa');
    await NSStorage.recall(key: 'spyreps');
    // await NSStorage.recall(key: 'applng');
    return 'fa';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadLngs(),
      builder: (context, data) {
        if (!splashShown) return MySplashScreen();

        if (data.connectionState != ConnectionState.done)
          return Center(child: NSText('loading...'));

        if (applng == 'fa' || data.data == 'fa')
          NSText.fontfamily = 'IRANSansWeb(FaNum)';
        else
          NSText.fontfamily = null;

        if (data.data != null)
          return GameSelectionScreen(onLanguageSelected: () {
            NSStorage.memorise(key: 'applng', value: null);
            this.setState(() => applng = null);
          });
        else
          return NSScaffold(
            body: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                      height: 240,
                      child: Image(
                          image: AssetImage('assets/images/game-boy.png'))),
                  NSRaisedButton.stdPadd(
                      darkColor: Colors.grey[600],
                      lightColor: NSMaterializedColors.black,
                      body: NSText.inverted('English'),
                      onPressed: () => _setLanguage('en')),
                  SizedBox(
                    height: 8,
                  ),
                  NSRaisedButton.stdPadd(
                    darkColor: Colors.grey[600],
                    lightColor: NSMaterializedColors.black,
                    body: NSText.inverted('Persian'),
                    onPressed: () => _setLanguage('fa'),
                  ),
                ],
              ),
            ),
          );
      },
    );
  }
}
