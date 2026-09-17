class ClockFormatter {
  static String formatTime(DateTime time){
    int hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final second = time.second.toString().padLeft(2, '0');

    final period = hour >=12 ? "PM" : "AM";
    hour = hour % 12 ;
    if (hour == 0){
      hour = 12;
    }

    return '$hour:$minute:$second $period';
  }

  static String formatOffset(Duration offset){
    final totalMinutes = offset.inMinutes;

    final sign = totalMinutes >= 0 ? "+" : "-";
    final absoluteMinute = totalMinutes.abs();

    final hour = absoluteMinute ~/ 60;
    final minutes =absoluteMinute % 60;


    if (minutes == 0){
      return "GMT$sign$hour";
    }

    return 'GMT$sign$hour${minutes.toString().padLeft(2,'0')}';
  }
}