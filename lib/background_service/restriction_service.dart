import 'dart:async';
// import 'dart:ui'; - MAYBE GET IT BACK HERE.
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:parentalctrl/firebase_options.dart';
import 'package:parentalctrl/models/usageinformation.dart';
import 'package:parentalctrl/models/user.dart';
import 'package:parentalctrl/services/children_service.dart';
import 'package:parentalctrl/services/usage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usage_stats/usage_stats.dart';

const String kill = 'STOP_SERVICE';
// FUNCTIONALITY FOR RESTRICTION.
List<UserInformation> oldStats = [];
String openedApp = '';
int FULL_DAY = 86400000;
Map<String, int> flags = {};
Map<String, bool> isOpen = {
  "YouTube": false,
  "Facebook": false,
  "Instagram": false,
};
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
    fetchChild(oldStats);
  });
}

fetchChild(List<UserInformation> oldStatsPass) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? uid = sharedPreferences.getString('user_id');
  if (uid != null) {
    final DatabaseReference ref = FirebaseDatabase.instance.ref('users');
    DatabaseEvent event = await ref.child('children/$uid/apps').once();
    DataSnapshot dataSnapshot = event.snapshot;
    Map<String, dynamic> apps =
        Map<String, dynamic>.from(dataSnapshot.value as Map);
    apps.removeWhere((key, value) => apps[key]["enabled"] == true);
    if (apps.isNotEmpty) {
      UsageService usageService = UsageService();
      List<UserInformation> restrictedUsageInformations =
          await usageService.getRestrictedAppsUsageForToday(apps);
      for (UserInformation restrictedUsageInformation
          in restrictedUsageInformations) {
        if (restrictedUsageInformation.untilReactivation == true) {
          for (UserInformation oldAppInformation in oldStatsPass) {
            print("OLD APP TIME : ${oldAppInformation.lastTimeUsed}");
            print("NEW APP TIME : ${restrictedUsageInformation.lastTimeUsed}");
            print(
                "ARE APPS THE SAME ${oldAppInformation.packageName == restrictedUsageInformation.packageName}");
            print(
                "IS THE APP OPEN? ${isOpen[restrictedUsageInformation.appName]}");
            print(
                "------------------------------------------------------------");

            if (restrictedUsageInformation.lastTimeUsed !=
                    oldAppInformation.lastTimeUsed &&
                oldAppInformation.packageName ==
                    restrictedUsageInformation.packageName &&
                isOpen[restrictedUsageInformation.appName] == false) {
              print(
                  "${restrictedUsageInformation.appName} IS OPEN ${isOpen[restrictedUsageInformation.appName]}");
              FlutterOverlayWindow.showOverlay();
              isOpen[restrictedUsageInformation.appName] = true;
            } else if (restrictedUsageInformation.lastTimeUsed !=
                    oldAppInformation.lastTimeUsed &&
                oldAppInformation.packageName ==
                    restrictedUsageInformation.packageName &&
                isOpen[restrictedUsageInformation.appName] == true) {
              FlutterOverlayWindow.closeOverlay();
              isOpen[restrictedUsageInformation.appName] = false;
              print(
                  "${restrictedUsageInformation.appName} IS OPEN ${isOpen[restrictedUsageInformation.appName]}");
            }
          }
        }
      }
      oldStats = restrictedUsageInformations;
    }
  }
}
