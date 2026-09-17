import 'package:alarm_app/core/services/alarm_notification_service.dart';
import 'package:alarm_app/data/data_sources/alarm_database.dart';
import '../../data/repositories/alarm_repositori.dart';

class ServiceLocator {
  static final alarmDatabase = AlarmDatabase();

  static final alarmNotificationService =
  AlarmNotificationService();

  static late final AlarmRepository alarmRepository;

  static Future<void> init() async {
    await alarmNotificationService.initialize();

    alarmRepository = AlarmRepository(
      alarmDatabase,
      alarmNotificationService,
    );
  }
}