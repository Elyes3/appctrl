class Parent {
  String firstName;
  String lastName;
  String email;
  Parent(this.firstName, this.lastName, this.email);
}

class App {
  String dataDir;
  bool enabled;
  int installedOn;
  int updatedOn;
  String name;
  bool untilReactivation;
  int time;
  int consumedTime;
  String packageName;
  App(this.dataDir, this.enabled, this.installedOn, this.updatedOn, this.name,
      this.untilReactivation, this.time, this.packageName, this.consumedTime);
}

class Child {
  String childId;
  String firstName;
  String lastName;
  String email;
  String parentId;
  List<App> apps;
  Child(this.childId, this.firstName, this.lastName, this.email, this.parentId,
      this.apps);
}

class UserData {
  String? email;
  String? uid;
  String? firstName;
  String? lastName;
  bool? isParent;
  String? message;
  List<dynamic>? childrenIds;
  UserData(this.uid, this.email, this.firstName, this.childrenIds,
      this.lastName, this.isParent, this.message);
  UserData.errorMessage(this.message);
  UserData.successfulMessage(this.message);
}
