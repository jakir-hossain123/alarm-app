import 'dart:io';

import 'package:alarm_app/data/models/alarm_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AlarmNotificationService {
  static const String _alarmChannelId = 'alarm_channel_v2';

  final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    final timezone = await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(
      tz.getLocation(timezone.identifier),
    );

    if (Platform.isAndroid) {
      final notificationStatus = await Permission.notification.status;
      if (notificationStatus.isDenied || notificationStatus.isPermanentlyDenied) {
        await Permission.notification.request();
      }

      final exactAlarmStatus = await Permission.scheduleExactAlarm.status;
      if (exactAlarmStatus.isDenied || exactAlarmStatus.isPermanentlyDenied) {
        await Permission.scheduleExactAlarm.request();
      }
    }

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(
      settings: settings,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundNotificationTap,
    );

    final androidPlugin =
    _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.requestExactAlarmsPermission();
    await androidPlugin?.requestFullScreenIntentPermission();

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _alarmChannelId,
        'Alarms',
        description: 'Alarm notifications',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        sound: RawResourceAndroidNotificationSound('alarm_sound'),
      ),
    );
  }

  static void _onBackgroundNotificationTap(NotificationResponse response) {}

  Future<void> scheduleAlarm(AlarmModel alarm) async {
    if (!alarm.isEnabled) return;


    print('SCHEDULING ALARM: ${alarm.id}');
    print('ALARM TIME: ${alarm.hour}:${alarm.minute}');
    print('ALARM REPEAT: ${alarm.repeatDays}');


    await cancelAlarm(alarm.id);

    if (alarm.repeatDays.isEmpty ||
        alarm.repeatDays.first == 'Once') {
      await _scheduleOnce(alarm);
      return;
    }

    for (final day in alarm.repeatDays) {
      await _scheduleWeekly(
        alarm,
        day,
      );
    }
  }

  Future<void> _scheduleOnce(AlarmModel alarm) async {
    final now = tz.TZDateTime.now(tz.local);

    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      alarm.hour,
      alarm.minute,
    );

    if (!scheduledDate.isAfter(now)) {
      scheduledDate = scheduledDate.add(
        const Duration(days: 1),
      );
    }

    print('SCHEDULED DATE: $scheduledDate');

    try {
      print('BEFORE ZONED SCHEDULE');

      await _notifications.zonedSchedule(
        id: _notificationId(alarm.id),
        title: alarm.label,
        body: 'Alarm is ringing',
        scheduledDate: scheduledDate,
        notificationDetails: _notificationDetails(alarm),
        androidScheduleMode:
        AndroidScheduleMode.exactAllowWhileIdle,
      );

      print('AFTER ZONED SCHEDULE');
      print('NOTIFICATION SCHEDULED SUCCESSFULLY');
    } catch (e, stackTrace) {
      print('ZONED SCHEDULE ERROR: $e');
      print(stackTrace);
    }
  }

  Future<void> _scheduleWeekly(
      AlarmModel alarm,
      String day,
      ) async {
    final now = tz.TZDateTime.now(tz.local);

    final targetWeekday = _getWeekday(day);

    var daysUntil = targetWeekday - now.weekday;

    if (daysUntil < 0) {
      daysUntil += 7;
    }

    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      alarm.hour,
      alarm.minute,
    ).add(
      Duration(days: daysUntil),
    );

    if (!scheduledDate.isAfter(now)) {
      scheduledDate = scheduledDate.add(
        const Duration(days: 7),
      );
    }

    final notificationId = _notificationId(
      '${alarm.id}_$day',
    );

    await _notifications.zonedSchedule(
      id: notificationId,
      title: alarm.label,
      body: 'Alarm is ringing',
      scheduledDate: scheduledDate,
      notificationDetails: _notificationDetails(alarm),
      androidScheduleMode:
      AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents:
      DateTimeComponents.dayOfWeekAndTime,
    );
  }

  NotificationDetails _notificationDetails(
      AlarmModel alarm,
      ) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _alarmChannelId,
        'Alarms',
        channelDescription: 'Alarm notifications',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound(
          'alarm_sound',
        ),
        enableVibration: alarm.isVibrationEnabled,
        fullScreenIntent: true,
        category: AndroidNotificationCategory.alarm,
        visibility: NotificationVisibility.public,
      ),
    );
  }

  Future<void> cancelAlarm(String id) async {
    await _notifications.cancel(
      id: _notificationId(id),
    );

    for (final day in [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ]) {
      await _notifications.cancel(
        id: _notificationId('${id}_$day'),
      );
    }
  }

  int _notificationId(String id) {
    return id.hashCode & 0x7fffffff;
  }

  int _getWeekday(String day) {
    switch (day) {
      case 'Monday':
        return DateTime.monday;
      case 'Tuesday':
        return DateTime.tuesday;
      case 'Wednesday':
        return DateTime.wednesday;
      case 'Thursday':
        return DateTime.thursday;
      case 'Friday':
        return DateTime.friday;
      case 'Saturday':
        return DateTime.saturday;
      case 'Sunday':
        return DateTime.sunday;
      default:
        return DateTime.monday;
    }
  }
}