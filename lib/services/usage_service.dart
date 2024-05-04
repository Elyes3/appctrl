import 'package:parentalctrl/models/usageinformation.dart';
import 'package:usage_stats/usage_stats.dart';

class UsageService {
  Future<List<UserInformation>> getRestrictedAppsUsageForToday(
      Map<dynamic, dynamic> restrictedApps) async {
    DateTime now = DateTime.now();
    DateTime startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
    DateTime endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    List<UsageInfo> usageInformations =
        await UsageStats.queryUsageStats(startDate, endDate);
    List<UserInformation> restrictedUsageInformations = [];
    for (String key in restrictedApps.keys) {
      for (UsageInfo usageInformation in usageInformations) {
        if (usageInformation.packageName ==
            restrictedApps[key]["packageName"]) {
          restrictedUsageInformations.add(UserInformation(
              usageInformation.lastTimeUsed,
              usageInformation.totalTimeInForeground,
              restrictedApps[key]["name"],
              usageInformation.packageName,
              restrictedApps[key]["enabled"],
              restrictedApps[key]["time"],
              restrictedApps[key]["consumedTime"],
              restrictedApps[key]["untilReactivation"]));
        }
      }
    }
    return restrictedUsageInformations;
  }
}
