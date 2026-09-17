class AlarmModel {
  final String id;
  final int hour;
  final int minute;
  final bool isEnabled;
  final String label;
  final List<String> repeatDays;
  final bool isVibrationEnabled;
  final String ringtone;
  final int snoozeMinutes;

  AlarmModel({
    required this.id,
    required this.hour,
    required this.minute,
    required this.isEnabled,
    required this.label,
    required this.repeatDays,
    required this.isVibrationEnabled,
    required this.ringtone,
    required this.snoozeMinutes,
  });

  AlarmModel copyWith({
    String? id,
    int? hour,
    int? minute,
    bool? isEnabled,
    String? label,
    List<String>? repeatDays,
    bool? isVibrationEnabled,
    String? ringtone,
    int? snoozeMinutes,
  }) {
    return AlarmModel(
      id: id ?? this.id,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      isEnabled: isEnabled ?? this.isEnabled,
      label: label ?? this.label,
      repeatDays: repeatDays ?? this.repeatDays,
      isVibrationEnabled:
      isVibrationEnabled ?? this.isVibrationEnabled,
      ringtone: ringtone ?? this.ringtone,
      snoozeMinutes: snoozeMinutes ?? this.snoozeMinutes,
    );
  }
}