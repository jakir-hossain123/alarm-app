import 'package:alarm_app/data/models/alarm_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AlarmDatabase {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(
      databasePath,
      'alarm_app.db',
    );

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE alarms (
            id TEXT PRIMARY KEY,
            hour INTEGER NOT NULL,
            minute INTEGER NOT NULL,
            isEnabled INTEGER NOT NULL,
            label TEXT NOT NULL,
            repeatDays TEXT NOT NULL,
            isVibrationEnabled INTEGER NOT NULL,
            ringtone TEXT NOT NULL,
            snoozeMinutes INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insertAlarm(AlarmModel alarm) async {
    final db = await database;

    await db.insert(
      'alarms',
      {
        'id': alarm.id,
        'hour': alarm.hour,
        'minute': alarm.minute,
        'isEnabled': alarm.isEnabled ? 1 : 0,
        'label': alarm.label,
        'repeatDays': alarm.repeatDays.join(','),
        'isVibrationEnabled':
        alarm.isVibrationEnabled ? 1 : 0,
        'ringtone': alarm.ringtone,
        'snoozeMinutes': alarm.snoozeMinutes,
      },
    );
  }

  Future<List<AlarmModel>> getAlarms() async {
    final db = await database;

    final result = await db.query('alarms');

    return result.map((map) {
      return AlarmModel(
        id: map['id'] as String,
        hour: map['hour'] as int,
        minute: map['minute'] as int,
        isEnabled: map['isEnabled'] == 1,
        label: map['label'] as String,
        repeatDays: (map['repeatDays'] as String)
            .split(',')
            .where((day) => day.isNotEmpty)
            .toList(),
        isVibrationEnabled:
        map['isVibrationEnabled'] == 1,
        ringtone: map['ringtone'] as String,
        snoozeMinutes: map['snoozeMinutes'] as int,
      );
    }).toList();
  }

  Future<void> deleteAlarm(String id) async {
    final db = await database;

    await db.delete(
      'alarms',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateAlarm(AlarmModel alarm) async {
    final db = await database;

    await db.update(
      'alarms',
      {
        'hour': alarm.hour,
        'minute': alarm.minute,
        'isEnabled': alarm.isEnabled ? 1 : 0,
        'label': alarm.label,
        'repeatDays': alarm.repeatDays.join(','),
        'isVibrationEnabled':
        alarm.isVibrationEnabled ? 1 : 0,
        'ringtone': alarm.ringtone,
        'snoozeMinutes': alarm.snoozeMinutes,
      },
      where: 'id = ?',
      whereArgs: [alarm.id],
    );
  }
}