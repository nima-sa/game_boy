import 'package:flutter/material.dart';
import 'package:game_boy/Mafia/MafiaRole.dart';
import 'package:game_boy/Mafia/MafiaRoleInfo.dart';
import 'package:game_boy/NS_Lib/NSCaptiveText.dart';
import 'package:game_boy/NS_Lib/NSColor.dart';
import 'package:game_boy/NS_Lib/NSIcon.dart';
import 'package:game_boy/NS_Lib/NSLocalizer.dart';
import 'package:game_boy/NS_Lib/NSAppBar.dart';
import 'package:game_boy/NS_Lib/NSMaterializedColors.dart';
import 'package:game_boy/NS_Lib/NSScaffold.dart';

import 'MafiaInGameScreen.dart';

class MafiaRoleDestributor extends StatefulWidget {
  final Map<String, List<MafiaRoleHolder>> roles;
  MafiaRoleDestributor(this.roles);

  @override
  _MafiaRoleDestributorState createState() => _MafiaRoleDestributorState();
}

class _MafiaRoleDestributorState extends State<MafiaRoleDestributor> {
  List<MafiaRoleHolder> roles = [];
  List<int> visitedIndexes = [];
  List<MafiaRoleHolder> selectedRoles = [];
  MafiaRoleHolder currentlySelectedRole;
  bool gameStarted = false;
  bool viewRoles = false;

  @override
  void dispose() {
    currentlySelectedRole = null;
    gameStarted = false;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final tmpRoles = widget.roles.keys
        .map((key) => widget.roles[key])
        .map((roles) => roles.map((role) => role))
        .expand((i) => i)
        .where((role) => role.count > 0)
        .toList();

    List<MafiaRoleHolder> mafias =
        tmpRoles.where((r) => r.role == Role.mafia).toList();
    List<MafiaRoleHolder> polices =
        tmpRoles.where((r) => r.role == Role.police).toList();

    final police = polices.length > 0 ? polices.first : null;

    final mafia = mafias.length > 0 ? mafias.first : null;

    final rest =
        tmpRoles.where((r) => (r.role != Role.police && r.role != Role.mafia));

    for (int i = 0; i < (police?.count ?? 0); i++)
      roles.add(MafiaRoleHolder(Role.police, true, RoleClass.good, count: 1));

    for (int i = 0; i < (mafia?.count ?? 0); i++)
      roles.add(MafiaRoleHolder(Role.mafia, true, RoleClass.bad, count: 1));

    roles.addAll(rest);
    roles.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return NSScaffold(
      darkBackgroundColor:
          NSColor.platform(iOS: Colors.black, android: Colors.grey[850]),
      navBar: NSAppBar(
        title: NScaptiveTextNavBar(
          viewRoles
              ? NSLocalizer.translate('orderedBySelection')
              : NSLocalizer.translate('selectRoles'),
          color: viewRoles ? Colors.red : null,
          lightColor: Colors.black,
        ),
        iOSLightItemsColor: Colors.black,
        iOSDarkItemsColor: Colors.white,
        backgroundColor: NSColor.dynamic(
          light: Colors.white,
          dark: NSMaterializedColors.black,
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  child: GridView.builder(
                    itemCount: roles.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4),
                    itemBuilder: (context, index) {
                      final visited = visitedIndexes.contains(index);
                      roles[index].idx = index;
                      final MafiaRoleHolder theRoleToShow =
                          viewRoles ? selectedRoles[index] : roles[index];
                      Widget child;
                      if (visited && viewRoles) {
                        child = NSText(
                          '${index + 1}\n' +
                              NSLocalizer.translate(theRoleToShow.strRole,
                                  sub: 'mafia'),
                          color: Colors.white,
                        );
                      } else if (visited && !viewRoles) {
                        child = NSIcon(
                          Icons.remove_red_eye,
                          darkColor: Colors.white,
                          lightColor: Colors.white,
                        );
                      } else {
                        child = NSText('${index + 1}');
                      }

                      return Padding(
                        padding: EdgeInsets.all(4.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                MediaQuery.of(context).platformBrightness ==
                                        Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                            backgroundColor:
                                MediaQuery.of(context).platformBrightness ==
                                        Brightness.light
                                    ? Colors.grey[300]
                                    : Colors.grey[700],
                            disabledBackgroundColor: Colors.blue[900],
                          ),
                          child: Center(
                            child: child,
                          ),
                          onPressed: visited
                              ? null
                              : () {
                                  roles[index].isAssigned = true;
                                  this.visitedIndexes.add(index);
                                  this.selectedRoles.add(roles[index]);
                                  setState(() =>
                                      currentlySelectedRole = roles[index]);
                                },
                        ),
                      );
                    },
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Divider(
                      height: 0,
                      color: Colors.black,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: _createBottons(),
                    ),
                  ],
                ),
              ],
            ),
            _roleDescription(),
          ],
        ),
      ),
    );
  }

  List<Widget> _createBottons() {
    List<Widget> buttons = [
      Expanded(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor:
                MediaQuery.of(context).platformBrightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
            backgroundColor:
                MediaQuery.of(context).platformBrightness == Brightness.light
                    ? Colors.grey[300]
                    : Colors.grey[700],
            padding: EdgeInsets.fromLTRB(
                8, 8, 8, MediaQuery.of(context).padding.bottom + 8),
          ),
          child: NSText(NSLocalizer.translate('startGame')),
          onPressed: () {
            if (roles.length != visitedIndexes.length) {
              NSScaffold.showAlert(
                context,
                dismissTitle: NSLocalizer.translate('ok'),
                title: NSCaptiveTextAlertTitle(
                  NSLocalizer.translate('thereAreStrayRoles', sub: 'mafia'),
                ),
              );
              return;
            }
            this.setState(() {
              gameStarted = true;
              viewRoles = false;
            });
            NSScaffold.pushScreen(context, MafiaInGameScreen(selectedRoles));
          },
        ),
      ),
    ];

    if (gameStarted) {
      buttons.insert(
        0,
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor:
                  MediaQuery.of(context).platformBrightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
              backgroundColor:
                  MediaQuery.of(context).platformBrightness == Brightness.light
                      ? Colors.grey[300]
                      : Colors.grey[700],
              padding: EdgeInsets.fromLTRB(
                  8, 8, 8, MediaQuery.of(context).padding.bottom + 8),
            ),
            child: NSText(NSLocalizer.translate('viewRoles')),
            onPressed: () {},
            onLongPress: () {
              setState(() {
                viewRoles = !viewRoles;
              });
              // NSScaffold.pushScreen(context, ViewRolesScreen(roles));
            },
          ),
        ),
      );
    }

    return buttons;
  }

  Widget _roleDescription() {
    if (currentlySelectedRole == null) {
      return Container();
    } else {
      return MafiaRoleInfo(currentlySelectedRole, () {
        this.setState(() => currentlySelectedRole = null);
      });
    }
  }
}
