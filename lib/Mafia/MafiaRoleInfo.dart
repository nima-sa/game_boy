import 'package:flutter/material.dart';
import 'package:game_boy/Mafia/MafiaRole.dart';
import 'package:game_boy/NS_Lib/NSCaptiveText.dart';
import 'package:game_boy/NS_Lib/NSLocalizer.dart';
import 'package:game_boy/NS_Lib/NSMaterializedColors.dart';
import 'package:game_boy/NS_Lib/NSRaisedButton.dart';

class MafiaRoleInfo extends StatelessWidget {
  final MafiaRoleHolder role;
  final VoidCallback callback;

  MafiaRoleInfo(this.role, this.callback);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: role == null ? 0 : 1,
          child: Container(
            color: Colors.blue,
            // color: Color(0xAA000000),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: MediaQuery.of(context).platformBrightness ==
                        Brightness.light
                    ? Colors.white //Colors.grey[500]
                    : Colors.black), //Colors.grey[700]),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  8, 8, 8, MediaQuery.of(context).padding.bottom + 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                            // height: 120,
                            flex: 1,
                            child: Image.asset(
                                'assets/mafia/${role.strRole}_icon.png')),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color:
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(32, 4, 32, 4),
                              child: SizedBox(
                                width: 450,
                                child: NSText.inverted(
                                  NSLocalizer.translate(role.strRole,
                                      sub: 'mafia'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 23),
                                  // color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: NSText(
                          NSLocalizer.translate(role.strRole + '_info',
                              sub: 'mafia'),
                          textDirection: NSLocalizer.textDirection,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    child: NSRaisedButton(
                      lightColor: NSMaterializedColors.black,
                      darkColor: NSMaterializedColors.white,
                      androidSplashColor: Colors.grey,
                      body: Material(
                          color: Colors.transparent,
                          child:
                              NSText.inverted(NSLocalizer.translate('done'))),
                      onPressed: callback,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
