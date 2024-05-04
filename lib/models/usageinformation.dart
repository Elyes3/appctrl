class UserInformation {
  String? lastTimeUsed;
  String? totalTimeInForeground;
  String appName;
  String? packageName;
  bool untilReactivation;
  bool enabled;
  int time;
  int consumedTime;
  UserInformation(
      this.lastTimeUsed,
      this.totalTimeInForeground,
      this.appName,
      this.packageName,
      this.enabled,
      this.time,
      this.consumedTime,
      this.untilReactivation);
}
