import "package:flutter_overlay_window/flutter_overlay_window.dart";
import "package:usage_stats/usage_stats.dart";

class PermissionService {
  Future<bool> checkOverlayPermissions() async {
    bool? overlayWindowPermission =
        await FlutterOverlayWindow.isPermissionGranted();
    return overlayWindowPermission;
  }

  Future<bool> checkUsageStatsPermissions() async {
    bool? usageStatsPermission = await UsageStats.checkUsagePermission();
    return usageStatsPermission ?? false;
  }

  Future<bool> grantOverlayPermissions() async {
    bool? overlayWindowPermissionGranted =
        await FlutterOverlayWindow.requestPermission();
    return overlayWindowPermissionGranted ?? false;
  }

  Future<bool> grantUsageStatsPermissions() async {
    await UsageStats.grantUsagePermission();
    bool? usageStats = await UsageStats.checkUsagePermission();
    return usageStats ?? false;
  }
}
