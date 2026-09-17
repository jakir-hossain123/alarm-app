import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class TimeZoneUtils {
  static void initialize (){
    tz.initializeTimeZones();
  }
  static tz.TZDateTime getCurrentTime (String timeZone){
    final location = tz.getLocation(timeZone);
    return tz.TZDateTime.now(location);
  }
}