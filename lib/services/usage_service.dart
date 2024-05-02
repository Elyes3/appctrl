import 'package:usage_stats/usage_stats.dart';

class UsageService {
  Future<List<UsageInfo>> getRestrictedAppsUsageForToday(
      Map<dynamic, dynamic> restrictedApps) async {
    print("HELLO GOT HERE");
    DateTime now = DateTime.now();
    DateTime startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
    DateTime endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    List<UsageInfo> usageStats =
        await UsageStats.queryUsageStats(startDate, endDate);
    if (restrictedApps.isNotEmpty) {
      for (String key in restrictedApps.keys) {
        print("IN STATISTICS ${restrictedApps[key]}");
      }
      List<UsageInfo> usageStatsResult = [];
      for (String key in restrictedApps.keys) {
        for (UsageInfo usageStat in usageStats) {
          if (usageStat.packageName == restrictedApps[key]["packageName"]) {
            usageStatsResult.add(usageStat);
          }
        }
      }
      for (UsageInfo usageStatResult in usageStatsResult) {
        print(
            'firstTimeStamp : ${usageStatResult.firstTimeStamp}, lastTimeStamp: ${usageStatResult.lastTimeStamp}, lastTimeUsed: ${usageStatResult.lastTimeUsed},TotalTimeInForeground: ${usageStatResult.totalTimeInForeground}');
        return usageStats;
      }
    }
    return [];
  }
}
