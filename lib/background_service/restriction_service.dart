import 'dart:async';
// import 'dart:ui'; - MAYBE GET IT BACK HERE.
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:parentalctrl/firebase_options.dart';
import 'package:parentalctrl/models/user.dart';
import 'package:parentalctrl/services/children_service.dart';
import 'package:parentalctrl/services/usage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usage_stats/usage_stats.dart';

const String kill = 'STOP_SERVICE';
// FUNCTIONALITY FOR RESTRICTION.
List<UsageInfo> oldStats = [];
String openedApp = '';
int FULL_DAY = 86400000;
Map<String, int> flags = {};
@pragma('vm:entry-point')
onServiceLaunch(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  service.on(kill).listen((event) {
    service.stopSelf();
  });
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? uid = sharedPreferences.getString('user_id');
  print("CODE IS WORKING");
  final DatabaseReference ref = FirebaseDatabase.instance.ref('users');
  DatabaseEvent event = await ref.child('children/$uid').once();
  DataSnapshot dataSnapshot = event.snapshot;
  Map<String, dynamic> childMap =
      Map<String, dynamic>.from(dataSnapshot.value as Map);
  Map<dynamic, dynamic> apps = childMap["apps"] ?? {};
  UsageService usageService = UsageService();
  oldStats = await usageService.getRestrictedAppsUsageForToday(apps);
  Timer.periodic(const Duration(seconds: 2), (timer) {
    print("CODE IS RUNNING");
    fetchChild(oldStats);
  });
}

fetchChild(List<UsageInfo> oldStatsPass) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? uid = sharedPreferences.getString('user_id');
  if (uid != null) {
    final DatabaseReference ref = FirebaseDatabase.instance.ref('users');
    DatabaseEvent event = await ref.child('children/$uid').once();
    DataSnapshot dataSnapshot = event.snapshot;
    Map<String, dynamic> childMap =
        Map<String, dynamic>.from(dataSnapshot.value as Map);
    Map<dynamic, dynamic> apps = childMap["apps"] ?? {};
    print("ALL APPS IN INTERATIONS $apps");
    apps.removeWhere((key, value) => apps[key]["enabled"] == true);
    if (apps.isNotEmpty) {
      UsageService usageService = UsageService();
      List<UsageInfo> currentStats =
          await usageService.getRestrictedAppsUsageForToday(apps);
      for (String key in apps.keys) {
        App app = appFromJson(apps[key]);
        if (!flags.containsKey(app.name)) {
          flags[app.name] = 0;
        }
        if (app.consumedTime == FULL_DAY) {
          ref.child('children/$uid/apps/${app.name}/consumedTime').set(0);
        }
        List<UsageInfo> currentApp = currentStats
            .where((usageStat) => usageStat.packageName == app.packageName)
            .toList();
        print(
            'CURRENT APP : firstTimeStamp : ${currentApp[0].firstTimeStamp}, lastTimeStamp: ${currentApp[0].lastTimeStamp}, lastTimeUsed: ${currentApp[0].lastTimeUsed},TotalTimeInForeground: ${currentApp[0].totalTimeInForeground}');
        List<UsageInfo> oldApp = oldStatsPass
            .where((oldStat) => oldStat.packageName == app.packageName)
            .toList();
        print(
            'OLD APP : firstTimeStamp : ${oldApp[0].firstTimeStamp}, lastTimeStamp: ${oldApp[0].lastTimeStamp}, lastTimeUsed: ${oldApp[0].lastTimeUsed},TotalTimeInForeground: ${oldApp[0].totalTimeInForeground}');
        if (app.untilReactivation == true) {
          flags[app.name] = 0;
          if (int.parse(currentApp[0].lastTimeUsed!) !=
              int.parse(oldApp[0].lastTimeUsed!)) {
            if (int.parse(currentApp[0].totalTimeInForeground ?? '0') -
                    int.parse(oldApp[0].totalTimeInForeground ?? '0') <
                200) {
              FlutterOverlayWindow.showOverlay();
              print("YOUTUBE OPEN");
            } else {
              FlutterOverlayWindow.closeOverlay();
              print("YOUTUBE CLOSED");
            }
          }
        } else {
          if (app.time > app.consumedTime) {
            flags[app.name] = 0;
            if (int.parse(currentApp[0].lastTimeUsed!) !=
                int.parse(oldApp[0].lastTimeUsed!)) {
              if (int.parse(currentApp[0].totalTimeInForeground ?? '0') -
                      int.parse(oldApp[0].totalTimeInForeground ?? '0') <
                  200) {
                print("YOUTUBE OPENED FOR TIME ");
                openedApp = app.name;
              } else {
                print("YOUTUBE CLOSED");
                openedApp = '';
              }
            }
          } else {
            if (flags[app.name] == 0) {
              FlutterOverlayWindow.showOverlay();
              flags[app.name] = flags[app.name]! + 1;
            }
            print("GOING IN ELSE");
            if (int.parse(currentApp[0].lastTimeUsed!) !=
                int.parse(oldApp[0].lastTimeUsed!)) {
              if (int.parse(currentApp[0].totalTimeInForeground ?? '0') -
                      int.parse(oldApp[0].totalTimeInForeground ?? '0') <
                  200) {
                print("WE ARE BLOCKING THE APP FOR TIME");
                openedApp = app.name;
                FlutterOverlayWindow.showOverlay();
              } else {
                print("WE AREN'T BLOCKING ANYTHING");
                openedApp = '';
                FlutterOverlayWindow.closeOverlay();
              }
            }
          }
        }
      }
      oldStats = currentStats;
      if (openedApp.isNotEmpty) {
        DataSnapshot dataSnapshot =
            await ref.child('children/$uid/apps/$openedApp/consumedTime').get();
        await ref
            .child('children/$uid/apps/$openedApp/consumedTime')
            .set((dataSnapshot.value as int) + 3000);
      }
    }
  }
}