import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:parentalctrl/background_service/restriction_service.dart';

Future<void> restrictApps() async {
  final restrictionService = FlutterBackgroundService();

  await restrictionService.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onServiceLaunch,
      // auto start service
      autoStart: true,
      isForegroundMode: true,
      autoStartOnBoot: true,
      initialNotificationTitle: "Flutter Challenge (background).",
      initialNotificationContent: "",
    ),
    iosConfiguration: IosConfiguration(),
  );
  restrictionService.startService();
}
