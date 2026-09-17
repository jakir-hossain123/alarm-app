import 'package:timezone/timezone.dart' as tz;

class ClockService {
  tz.TZDateTime getCurrentTime(String timeZone){
    final location = tz.getLocation(timeZone);
    
    return tz.TZDateTime.now(location);
  }
}