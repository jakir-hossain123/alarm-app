import 'package:alarm_app/data/models/alarm_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/alarm_provider.dart';
import 'add_alarm_screen.dart';

class AlarmScreen extends StatelessWidget {
  const AlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alarmProvider = context.watch<AlarmProvider>();
    final alarms = alarmProvider.alarms;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        actions: [
          if (alarmProvider.isSelectionMode)
            IconButton(
              onPressed: () {
                alarmProvider.deleteSelectedAlarms();
              },
              icon: const Icon(Icons.delete_outline),
            )
          else
            const Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: Icon(Icons.more_vert_outlined),
            ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAlarmTitle(context),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (final alarm in alarms)
                      _buildAlarmItem(context, alarm),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,

      floatingActionButton: alarmProvider.isSelectionMode
          ? null
          : FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor:
        Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddAlarmScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Short day name
  String _getShortDayName(String day) {
    const shortDays = {
      'Sunday': 'Sun',
      'Monday': 'Mon',
      'Tuesday': 'Tue',
      'Wednesday': 'Wed',
      'Thursday': 'Thu',
      'Friday': 'Fri',
      'Saturday': 'Sat',
    };

    return shortDays[day] ?? day;
  }

  // Repeat text
  String _getRepeatText(AlarmModel alarm) {
    if (alarm.repeatDays.length == 7) {
      return 'Every day';
    }

    if (alarm.repeatDays.length == 1) {
      if (alarm.repeatDays.first == 'Once') {
        return 'Ring once';
      }

      return '${_getShortDayName(alarm.repeatDays.first)}';
    }

    return alarm.repeatDays
        .map((day) => _getShortDayName(day))
        .join(', ');
  }

  Widget _buildAlarmTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        Text(
          'Alarm',
          style: Theme.of(context).textTheme.headlineMedium,
        ),

        const SizedBox(height: 4),

        Text(
          'Alarm will ring in 7 h 5 min.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildAlarmItem(
      BuildContext context,
      AlarmModel alarm,
      ) {
    final alarmProvider = context.watch<AlarmProvider>();

    final isSelected =
    alarmProvider.selectedAlarmIds.contains(alarm.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),

          child: GestureDetector(
            onLongPress: () {
              context
                  .read<AlarmProvider>()
                  .toggleSelection(alarm.id);
            },

            onTap: () {
              if (alarmProvider.isSelectionMode) {
                context
                    .read<AlarmProvider>()
                    .toggleSelection(alarm.id);
              }
            },

            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 8,
              ),

              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.grey[200]
                    : Colors.transparent,

                borderRadius: BorderRadius.circular(12),
              ),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${alarm.hour.toString().padLeft(2, '0')}:${alarm.minute.toString().padLeft(2, '0')}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                              fontSize: 36,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 6.0,
                              left: 9,
                            ),
                            child: Text(
                              alarm.hour < 12
                                  ? 'AM'
                                  : 'PM',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                fontSize: 15,
                                fontWeight:
                                FontWeight.w300,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      Text(
                        _getRepeatText(alarm),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                          fontSize: 14,
                        ),
                      ),


                    ],
                  ),

                  const Spacer(),

                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: alarm.isEnabled,

                      onChanged: (_) {
                        context
                            .read<AlarmProvider>()
                            .toggleAlarm(alarm.id);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const Divider(
          height: 1,
        ),
      ],
    );
  }
}