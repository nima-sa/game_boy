import 'package:flutter/material.dart';
import 'package:game_boy/Mafia/MafiaRoleDestributor.dart';
import 'package:game_boy/Mafia/MafiaRoleInfo.dart';
import 'package:game_boy/NS_Lib/NSCaptiveText.dart';
import 'package:game_boy/NS_Lib/NSColor.dart';
import 'package:game_boy/NS_Lib/NSLocalizer.dart';
import 'package:game_boy/NS_Lib/NSAppBar.dart';
import 'package:game_boy/NS_Lib/NSMaterializedColors.dart';
import 'package:game_boy/NS_Lib/NSScaffold.dart';

import 'MafiaRole.dart';

class MafiaMainScreen extends StatefulWidget {
  @override
  _MafiaMainScreenState createState() => _MafiaMainScreenState();
}

class _MafiaMainScreenState extends State<MafiaMainScreen> {
  // int allPlayesCount = 0;
  int selectedPlayersCount = 3;
  List<int> shortRoleCounter;
  MafiaRoleHolder currentlySelectedRole;
  int playersOfset = 4; // minus one. because indexes start from 0 :)
  double width;

  @override
  Widget build(BuildContext context) {
    width ??= MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: NSLocalizer.load('lang/mafia'),
      builder: (context, ss) {
        return Stack(
          children: [
            NSScaffold(
              darkBackgroundColor: NSColor.platform(
                  iOS: Colors.black, android: Colors.grey[850]),
              navBar:
                  // currentlySelectedRole != null
                  // ? null
                  // :
                  NSAppBar(
                backgroundColor: NSColor.dynamic(
                  light: Colors.white,
                  dark: NSMaterializedColors.black,
                ),
                iOSLightItemsColor: Colors.black,
                iOSDarkItemsColor: Colors.white,
                title: SizedBox(
                  width: 120,
                  child: NScaptiveTextNavBar(
                    // no need for futureBuilder::load('lang') since it has been cached already.
                    NSLocalizer.translate('mafia'),
                    lightColor: Colors.black,
                  ),
                ),
              ),
              body: SafeArea(
                bottom: false,
                child: Stack(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // _createTopContainer(),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: _makeRoleSliverLists(ss.data),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: RaisedButton(
                                    textColor: MediaQuery.of(context)
                                                .platformBrightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white,
                                    color: MediaQuery.of(context)
                                                .platformBrightness ==
                                            Brightness.light
                                        ? Colors.grey[300]
                                        : Colors.grey[700],
                                    padding: EdgeInsets.fromLTRB(
                                        8,
                                        8,
                                        8,
                                        MediaQuery.of(context).padding.bottom +
                                            8),
                                    child: Directionality(
                                      textDirection: NSLocalizer.textDirection,
                                      child: NSText(
                                          NSLocalizer.translate('continue')),
                                    ),
                                    onPressed: () {
                                      if (shortRoleCounter[1] >
                                              shortRoleCounter[0] +
                                                  shortRoleCounter[2] ||
                                          shortRoleCounter[1] ==
                                              shortRoleCounter[0] +
                                                  shortRoleCounter[2]) {
                                        NSScaffold.showAlert(
                                          context,
                                          dismissTitle:
                                              NSLocalizer.translate('ok'),
                                          title: NSCaptiveTextAlertTitle(
                                            NSLocalizer.translate(
                                                'mafiasCannotOutNumberCitizens',
                                                sub: 'mafia'),
                                          ),
                                        );
                                        return;
                                      }

                                      NSScaffold.pushScreen(
                                          context,
                                          MafiaRoleDestributor(
                                              _roleDistinguisher));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(bottom: false, child: _showRoleInfo())
          ],
        );
      },
    );
  }

  Widget _createTopContainer() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Directionality(
            textDirection: NSLocalizer.textDirection,
            child: NSText(
              NSLocalizer.translate('selectTheRoles_holdToSeeDescription'),
              size: 12,
            ),
          ),
        ),
        Directionality(
          textDirection: NSLocalizer.textDirection,
          child: NSText(NSLocalizer.translate('players') +
              NSLocalizer.numsToLng(
                  ': ${selectedPlayersCount + playersOfset}')),
        ),
        SizedBox(
          height: 49,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 50,
            itemBuilder: (context, idx) => Padding(
              padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
              child: Container(
                // height: 50,
                // width: 50,
                child: RaisedButton(
                  padding: EdgeInsets.zero,
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.light
                      ? (selectedPlayersCount - 1 == idx
                          ? Colors.blue
                          : Colors.blueGrey[500])
                      : (selectedPlayersCount - 1 == idx
                          ? Colors.blue
                          : Colors.blueGrey[500]),
                  child: NSText.inverted('${idx + playersOfset + 1}',
                      color: selectedPlayersCount - 1 == idx
                          ? Colors.white
                          : Colors.white),
                  onPressed: () {
                    selectedPlayersCount = idx + 1;
                    reCalcRoles();
                    setState(() {});
                  },
                ),
              ),
            ),
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
          ),
        ),
      ],
    );
  }

  Widget _showRoleInfo() {
    if (currentlySelectedRole == null) {
      return Container();
    } else {
      return MafiaRoleInfo(currentlySelectedRole,
          () => this.setState(() => currentlySelectedRole = null));
    }
  }

  void reCalcRoles() {
    var mafia = _roleDistinguisher['mafiaGroup'][0];
    var police = _roleDistinguisher['citizensGroup'][0];

    final otherMafias = _roleDistinguisher['mafiaGroup']
        .where((role) => role.isSelected && role.role != Role.mafia);

    var otherPolice = _roleDistinguisher['citizensGroup']
        .where((role) => role.isSelected && role.role != Role.police);

    var otherPlayers =
        _roleDistinguisher['grayGroup'].where((role) => role.isSelected);

    var otherMafiasCount = 0;
    var otherPoliceCount = 0;
    var grayPlayersCount = 0;

    if (otherMafias.length > 0)
      otherMafiasCount =
          otherMafias.map((e) => e.count).reduce((a, b) => a + b);

    if (otherPolice.length > 0)
      otherPoliceCount =
          otherPolice.map((e) => e.count).reduce((a, b) => a + b);

    if (otherPlayers.length > 0)
      grayPlayersCount =
          otherPlayers.map((e) => e.count).reduce((a, b) => a + b);

    final isMafiaSelected = mafia.isSelected;
    final isPoliceSelected = police.isSelected;

    if (isMafiaSelected) {
      final mafiaCount =
          (selectedPlayersCount + playersOfset) / 3 - otherMafiasCount;
      mafia.count = mafiaCount.toInt();
      if (mafia.count <= 0) {
        mafia.count = 0;
        mafia.isSelected = false;
      }
    }

    if (isPoliceSelected) {
      final policeCount = (selectedPlayersCount + playersOfset) -
          otherPoliceCount -
          (otherMafiasCount + mafia.count) -
          grayPlayersCount;
      police.count = policeCount;

      if (policeCount <= 0) {
        police.isSelected = false;
        police.count = 0;
      }
    }

    final total = otherMafiasCount +
        mafia.count +
        grayPlayersCount +
        otherPoliceCount +
        police.count;
    if (total > (selectedPlayersCount + playersOfset))
      selectedPlayersCount = total;
  }

  Widget _makeChip(String roles, Map<String, String> dict, Color color) {
    List<Widget> holder = [];
    for (var i = 0; i < _roleDistinguisher[roles].length; i++) {
      final MafiaRoleHolder role = _roleDistinguisher[roles][i];
      final text = (dict[role.strRole] ?? '') +
          ((role.count > 1) || (role.count > 0 && role.mustShowCount)
              ? NSLocalizer.numsToLng(' (${role.count})')
              : '');
      holder.add(
        Container(
          // constraints: BoxConstraints(minWidth: (width - 16) / 3),
          // color: Colors.red,
          child: Padding(
            padding: EdgeInsets.fromLTRB(3, 3, 3, 3),
            child: FlatButton(
              color: role.isSelected
                  ? color
                  : MediaQuery.of(context).platformBrightness ==
                          Brightness.light
                      ? Colors.blueGrey[400]
                      : Colors.grey[800],
              child: Directionality(
                textDirection: NSLocalizer.textDirection,
                child: SizedBox(
                  width: 120,
                  // constraints: BoxConstraints(minWidth: 120),
                  // constraints: BoxConstraints(minWidth: (width - 16) / 3),
                  child: NSText(
                    text,
                    color: role.isSelected ? Colors.white : Colors.white,
                  ),
                ),
              ),
              onLongPress: () =>
                  this.setState(() => currentlySelectedRole = role),
              onPressed: () {
                role.isSelected = !role.isSelected;
                role.count = role.isSelected ? 1 : 0;
                reCalcRoles();
                // if (role.isSelected &&
                //     (role.role == Role.police || role.role == Role.mafia)) {
                //   role.count = await _getNumbersOfRole();
                //   if (role.count == 0) role.isSelected = false;
                // }
                this.setState(() {});
              },
            ),
            // child: NSText(dict[mr.strRole] ?? ''),
          ),
        ),
      );
    }

    return SliverGrid.count(
      childAspectRatio: (3 / 1),
      crossAxisCount: 3,
      children: holder,
    );
  }

  Widget _makeRoleSliverLists(Map<String, String> dict) {
    if (dict == null) return Container(child: null);
    List<Widget> slivers = [
      SliverToBoxAdapter(
        child: _createTopContainer(),
      )
    ];
    var i = 0;
    // int allPlayesCount = 0;
    if (shortRoleCounter == null)
      shortRoleCounter =
          List.generate(_roleDistinguisher.keys.length, (i) => 0);

    for (var role in _roleDistinguisher.keys.toList()) {
      final color = MediaQuery.of(context).platformBrightness ==
              Brightness.light
          ? (i == 0 ? Colors.lightBlue : i == 1 ? Colors.red : Colors.green)
          : (i == 0 ? Colors.lightBlue : i == 1 ? Colors.red : Colors.green);
      final int roleGroupCount =
          _roleDistinguisher[role].map((e) => e.count).reduce((a, b) => a + b);
      // allPlayesCount += roleGroupCount;
      String title = dict[role];
      if (roleGroupCount > 0) title += ' ($roleGroupCount)';
      shortRoleCounter[i] = roleGroupCount;
      slivers.add(renderTitle(title, color));
      slivers.add(_makeChip(role, dict, color));
      i++;
    }
    // slivers.add(renderTitle(
    // NSLocalizer.translate('players') + ': $allPlayesCount', Colors.amber));
    // this.allPlayesCount = allPlayesCount;
    return CustomScrollView(slivers: slivers);
  }

  Widget renderTitle(String title, Color color,
      {Color textColor, FontWeight weight}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: color,
            // color: MediaQuery.of(context).platformBrightness == Brightness.light
            // ? Colors.black
            // : Colors.grey[600],
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: Directionality(
              textDirection: NSLocalizer.textDirection,
              child: NSText(
                NSLocalizer.numsToLng(title),
                color: textColor ?? Colors.white,
                // lightColor: Colors.white,
                textAlign: TextAlign.center,
                size: 16,
                weight: weight ?? FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  final Map<String, List<MafiaRoleHolder>> _roleDistinguisher = {
    'citizensGroup': [
      MafiaRoleHolder(Role.police, true, RoleClass.good,
          count: 5, mustShowCount: true),
      MafiaRoleHolder(Role.doctor, false, RoleClass.good),
      MafiaRoleHolder(Role.inspector, false, RoleClass.good),
      MafiaRoleHolder(Role.priest, false, RoleClass.good),
      MafiaRoleHolder(Role.invulnerable, false, RoleClass.good),
      MafiaRoleHolder(Role.gun, false, RoleClass.good),
      MafiaRoleHolder(Role.sniper, false, RoleClass.good),
      MafiaRoleHolder(Role.angel, false, RoleClass.good),
      MafiaRoleHolder(Role.martyr, false, RoleClass.good),
      MafiaRoleHolder(Role.bodyguard, false, RoleClass.good),
      MafiaRoleHolder(Role.mayor, false, RoleClass.good),
      MafiaRoleHolder(Role.virgin, false, RoleClass.good),
      MafiaRoleHolder(Role.freemason, false, RoleClass.good),
      MafiaRoleHolder(Role.sherif, false, RoleClass.good),
      MafiaRoleHolder(Role.hacker, false, RoleClass.good),
      MafiaRoleHolder(Role.baker, false, RoleClass.good),
    ],
    'mafiaGroup': [
      MafiaRoleHolder(Role.mafia, true, RoleClass.bad,
          count: 2, mustShowCount: true),
      MafiaRoleHolder(Role.godFather, false, RoleClass.bad),
      MafiaRoleHolder(Role.natasha, false, RoleClass.bad),
      MafiaRoleHolder(Role.lawyer, false, RoleClass.bad),
      MafiaRoleHolder(Role.terrorist, false, RoleClass.bad),
      MafiaRoleHolder(Role.strongMan, false, RoleClass.bad),
      MafiaRoleHolder(Role.offender, false, RoleClass.bad),
      MafiaRoleHolder(Role.witch, false, RoleClass.bad),
      MafiaRoleHolder(Role.interrogator, false, RoleClass.bad),
      MafiaRoleHolder(Role.poisonMaker, false, RoleClass.bad),
      MafiaRoleHolder(Role.traitor, false, RoleClass.bad),
      MafiaRoleHolder(Role.thief, false, RoleClass.bad),
    ],
    'grayGroup': [
      MafiaRoleHolder(Role.serialKiller, false, RoleClass.other),
      MafiaRoleHolder(Role.bartender, false, RoleClass.other),
      MafiaRoleHolder(Role.bard, false, RoleClass.other),
      MafiaRoleHolder(Role.jester, false, RoleClass.other),
    ]
  };
}
