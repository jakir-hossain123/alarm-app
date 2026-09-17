import 'package:alarm_app/data/models/alarm_model.dart';
import 'package:flutter/foundation.dart';

import '../../data/repositories/alarm_repositori.dart';

class AlarmProvider extends ChangeNotifier {
  final AlarmRepository _repository;

  AlarmProvider(this._repository);

  final List<AlarmModel> _alarms = [];

  final Set<String> _selectedAlarmIds = {};

  List<AlarmModel> get alarms => _alarms;

  Set<String> get selectedAlarmIds => _selectedAlarmIds;

  bool get isSelectionMode =>
      _selectedAlarmIds.isNotEmpty;

  Future<void> loadAlarms() async {
    final alarms = await _repository.getAlarms();

    _alarms
      ..clear()
      ..addAll(alarms);

    notifyListeners();
  }

  Future<void> addAlarm(AlarmModel alarm) async {
    await _repository.addAlarm(alarm);

    _alarms.add(alarm);

    notifyListeners();
  }

  Future<void> toggleAlarm(String id) async {
    final index = _alarms.indexWhere(
          (alarm) => alarm.id == id,
    );

    if (index == -1) return;

    final updatedAlarm = _alarms[index].copyWith(
      isEnabled: !_alarms[index].isEnabled,
    );

    await _repository.updateAlarm(updatedAlarm);

    _alarms[index] = updatedAlarm;

    notifyListeners();
  }

  Future<void> deleteAlarm(String id) async {
    await _repository.deleteAlarm(id);

    _alarms.removeWhere(
          (alarm) => alarm.id == id,
    );

    _selectedAlarmIds.remove(id);

    notifyListeners();
  }

  Future<void> deleteSelectedAlarms() async {
    final ids = _selectedAlarmIds.toList();

    for (final id in ids) {
      await _repository.deleteAlarm(id);
    }

    _alarms.removeWhere(
          (alarm) => _selectedAlarmIds.contains(alarm.id),
    );

    _selectedAlarmIds.clear();

    notifyListeners();
  }

  void selectAlarm(String id) {
    _selectedAlarmIds.add(id);
    notifyListeners();
  }

  void deselectAlarm(String id) {
    _selectedAlarmIds.remove(id);
    notifyListeners();
  }

  void toggleSelection(String id) {
    if (_selectedAlarmIds.contains(id)) {
      _selectedAlarmIds.remove(id);
    } else {
      _selectedAlarmIds.add(id);
    }

    notifyListeners();
  }

  void clearSelection() {
    _selectedAlarmIds.clear();
    notifyListeners();
  }
}