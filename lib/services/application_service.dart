import 'package:device_apps/device_apps.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> getInstalledApps(String uid, DatabaseReference ref) async {
  List<Application> apps = await DeviceApps.getInstalledApplications(
      onlyAppsWithLaunchIntent: true,
      includeSystemApps: true,
      includeAppIcons: true);
  for (var app in apps) {
    if (app.appName == 'YouTube' ||
        app.appName == 'Facebook' ||
        app.appName == 'Instagram') {
      DataSnapshot dataSnapshot = await ref
          .child('children')
          .child(uid)
          .child('apps')
          .child(app.appName)
          .get();
      if (dataSnapshot.value == null) {
        ref.child('children').child(uid).child('apps').child(app.appName).set({
          'name': app.appName,
          'packageName': app.packageName,
          'installedOn': app.installTimeMillis,
          'enabled': true,
          'dataDir': app.dataDir,
          'updatedOn': app.updateTimeMillis,
          'untilReactivation': false,
          'time': 0,
          'consumedTime': 0,
          'isUsed': false,
        });
      }
    }
  }
}
