import 'package:firebase_database/firebase_database.dart';
import 'package:parentalctrl/models/user.dart';
import 'package:parentalctrl/providers/children_provider.dart';
import 'package:parentalctrl/utils/date.dart';

class ChildrenService {
  final DatabaseReference ref = FirebaseDatabase.instance.ref("users");
  void listenForChildrenUpdates(
      String parentId, ChildrenProvider childrenProvider) {
    final DatabaseReference ref = FirebaseDatabase.instance.ref("users");
    ref.child("parents/$parentId/childrenIds").onValue.listen((event) async {
      if (parentId != null) {
        final DataSnapshot dataSnapshot =
            await ref.child("parents/$parentId").get();
        final parentData = dataSnapshot.value as Map;
        final childrenIds = parentData["childrenIds"];
        if (childrenIds != null) {
          await childrenProvider.fetchParentChildren(parentData["childrenIds"]);
        }
      }
    });
  }

  void listenForChildAppUpdate(
      String parentId, String childId, ChildrenProvider childrenProvider) {
    final DatabaseReference ref = FirebaseDatabase.instance.ref("users");
    ref.child("children/$childId/apps").onValue.listen((event) async {
      if (parentId != null) {
        final DataSnapshot dataSnapshot =
            await ref.child("parents/$parentId").get();
        final parentData = dataSnapshot.value as Map;
        final childrenIds = parentData["childrenIds"];
        if (childrenIds != null) {
          await childrenProvider.fetchParentChildren(parentData["childrenIds"]);
        }
      }
    });
  }

  Future<List<Child>> fetchParentChildren(List<dynamic>? childrenIds) async {
    List<Child> children = [];
    if (childrenIds != null) {
      for (var childId in childrenIds) {
        DatabaseEvent event = await ref.child('children/$childId').once();
        DataSnapshot dataSnapshot = event.snapshot;
        Map<String, dynamic> childMap =
            Map<String, dynamic>.from(dataSnapshot.value as Map);
        Map<dynamic, dynamic> apps = childMap["apps"] ?? {};
        List<App> appsList = [];
        if (apps.isNotEmpty) {
          apps.forEach((key, value) {
            appsList.add(App(
                value["dataDir"],
                value["enabled"],
                value["installedOn"],
                value["updatedOn"],
                value["name"],
                value["untilReactivation"],
                value["time"],
                value["packageName"],
                value["consumedTime"],
                value["isUsed"]));
          });
        }
        Child child = Child(
            childId,
            childMap['firstName'],
            childMap['lastName'],
            childMap['email'],
            childMap['parentId'],
            appsList);
        children.add(child);
      }
    }
    return children;
  }

  updateRestrictions(
      Child child, bool untilReactivation, String time, App app) async {
    app.untilReactivation = untilReactivation;
    app.enabled =
        (app.untilReactivation == false && (time == '00:00' || time.isEmpty))
            ? true
            : false;
    app.time = timeToMilliseconds(time);
    for (int i = 0; i < child.apps.length; i++) {
      if (child.apps[i].name == app.name) {
        child.apps[i] = app;
      }
    }

    await ref.child('children/${child.childId}').set(childToJson(child));
  }
}

Map<String, dynamic> childToJson(Child child) {
  Map<String, dynamic> json = {};
  json["childId"] = child.childId;
  json["email"] = child.email;
  json["firstName"] = child.firstName;
  json["lastName"] = child.lastName;
  json["parentId"] = child.parentId;
  json["apps"] = appsToJson(child.apps);
  return json;
}

Map<String, dynamic> appsToJson(List<App> apps) {
  Map<String, dynamic> jsonApps = {};
  for (App app in apps) {
    Map<String, dynamic> jsonApp = {};
    jsonApp["dataDir"] = app.dataDir;
    jsonApp["enabled"] = app.enabled;
    jsonApp["installedOn"] = app.installedOn;
    jsonApp["name"] = app.name;
    jsonApp["packageName"] = app.packageName;
    jsonApp["updatedOn"] = app.updatedOn;
    jsonApp["time"] = app.time;
    jsonApp["untilReactivation"] = app.untilReactivation;
    jsonApp["consumedTime"] = app.consumedTime;
    jsonApp["isUsed"] = app.isUsed;
    jsonApps[app.name] = jsonApp;
  }
  return jsonApps;
}

App appFromJson(Map<dynamic, dynamic> app) {
  return App(
      app["dataDir"],
      app["enabled"],
      app["installedOn"],
      app["updatedOn"],
      app["name"],
      app["untilReactivation"],
      app["time"],
      app["packageName"],
      app["consumedTime"],
      app["isUsed"]);
}
