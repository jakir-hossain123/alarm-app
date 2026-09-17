import 'package:alarm_app/core/services/alarm_notification_service.dart';
import 'package:alarm_app/data/data_sources/alarm_database.dart';
import 'package:alarm_app/data/models/alarm_model.dart';

class AlarmRepository {
  final AlarmDatabase _database;
  final AlarmNotificationService _notificationService;

  AlarmRepository(
      this._database,
      this._notificationService,
      );

  Future<List<AlarmModel>> getAlarms() async {
    return _database.getAlarms();
  }

  Future<void> addAlarm(AlarmModel alarm) async {
    await _database.insertAlarm(alarm);

    if (alarm.isEnabled) {
      await _notificationService.scheduleAlarm(alarm);
    }
  }

  Future<void> updateAlarm(AlarmModel alarm) async {
    await _database.updateAlarm(alarm);

    if (alarm.isEnabled) {
      await _notificationService.scheduleAlarm(alarm);
    } else {
      await _notificationService.cancelAlarm(alarm.id);
    }
  }

  Future<void> deleteAlarm(String id) async {
    await _database.deleteAlarm(id);

    await _notificationService.cancelAlarm(id);
  }
}