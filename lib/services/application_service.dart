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
      ref.child('children').child(uid).child('apps').child(app.appName).set({
        'name': app.appName,
        'packageName': app.packageName,
        'installedOn': app.installTimeMillis,
        'enabled': app.enabled,
        'dataDir': app.dataDir,
        'updatedOn': app.updateTimeMillis,
        'untilReactivation': true,
        'time': 0,
        'consumedTime': 0,
      });
    }
  }
}
