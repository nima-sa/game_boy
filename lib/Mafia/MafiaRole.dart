enum Role {
  police,
  doctor,
  inspector,
  priest,
  invulnerable,
  gun,
  sniper,
  angel,
  martyr,
  bodyguard,
  mayor,
  virgin,
  freemason,
  sherif,
  hacker,
  baker,
  mafia,
  godFather,
  natasha,
  lawyer,
  terrorist,
  strongMan,
  offender,
  witch,
  harlot,
  traitor,
  interrogator,
  poisonMaker,
  serialKiller,
  bartender,
  bard,
  jester,
  thief,

}

enum RoleClass {
  good, bad, other
}

class MafiaRoleHolder {
  // String playerName;
  Role role;
  bool isSelected;
  String strRole;
  int count = 0;
  RoleClass kClass;
  bool mustShowCount;
  bool isAssigned;
  int idx;

  MafiaRoleHolder(Role role, bool isSelected, RoleClass kClass,
      {int count = 0, bool mustShowCount = false}) {
    // this.playerName = playerName;
    this.role = role;
    this.isSelected = isSelected;
    this.strRole = role.toString().split('.').last;
    this.count = count;
    this.kClass = kClass;
    this.mustShowCount = mustShowCount;
    this.isAssigned = false;
    this.idx = -1;
  }
}
