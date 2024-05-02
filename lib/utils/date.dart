import 'package:intl/intl.dart';

String convertMillisToDate(int millisDate) {
  return DateFormat('dd/MM/yyyy')
      .format(DateTime.fromMillisecondsSinceEpoch(millisDate));
}

int timeToMilliseconds(String time) {
  if (time.isNotEmpty) {
    List<String> parts =
        time.split(':'); // Split the time string into hours and minutes
    time.split(':'); // Split the time string into hours and minutes
    int hours = int.parse(parts[0]); // Convert hours part to integer
    int minutes = int.parse(parts[1]); // Convert minutes part to integer
    return (hours * 3600 + minutes * 60) * 1000; // Calculate total milliseconds
  }
  return 0;
}

String millisToTime(int milliseconds) {
  int seconds = (milliseconds / 1000).round();
  int minutes = (seconds / 60).truncate();
  int hours = (minutes / 60).truncate();

  String hoursStr = (hours % 24).toString().padLeft(2, '0');
  String minutesStr = (minutes % 60).toString().padLeft(2, '0');

  return '$hoursStr:$minutesStr';
}
