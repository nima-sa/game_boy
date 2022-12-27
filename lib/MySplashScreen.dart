import 'package:flutter/material.dart';
import 'package:game_boy/NS_Lib/NSCaptiveText.dart';

import 'NS_Lib/NSColor.dart';
import 'NS_Lib/NSScaffold.dart';

class MySplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NSScaffold(
      darkBackgroundColor:
          NSColor.platform(iOS: Colors.black, android: Colors.grey[850]),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 60),
              Container(
                  height: 240,
                  child:
                      Image(image: AssetImage('assets/images/game-boy.png'))),
              Spacer(),
              NSText('By', color: Colors.grey),
              SizedBox(height: 2),
              NSText('Nima', weight: FontWeight.bold, size: 23),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
