import 'package:alarm_app/data/models/alarm_model.dart';
import 'package:alarm_app/presentasion/providers/alarm_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'alarm_repeat_screen.dart';

class AddAlarmScreen extends StatefulWidget {
  const AddAlarmScreen({super.key});

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  late int selectedHour;  //selected hour for what?
  late int selectedMinute; //selectedMinute for what?
  late bool isAm;

  bool isCustom = false;
  bool isVibrationEnabled = true;
  bool isSnoozeEnabled = true;

  final TextEditingController labelController = TextEditingController();

  final List<int> hours = List.generate(12, (index) => index + 1);
  final List<int> minutes = List.generate(60, (index) => index);

   List<String> selectedDays = [];

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    selectedHour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    selectedMinute = now.minute;
    isAm = now.hour < 12;
  }

  @override
  void dispose() {
    labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alarms = context.watch<AlarmProvider>().alarms;

    print('ALARM LIST LENGTH: ${alarms.length}');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
        ),
        title: const Text('Add alarm',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _saveAlarm,
            icon: const Icon(Icons.check),
          ),
        ],
      ),

      body:  GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23.0),
          child: SingleChildScrollView(
            child: Column(
              children: [

                Text(
                  'Alarm will ring in 1 day.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 13
                  ),
                ),

                const SizedBox(height: 30),

                _buildTimePicker(),

                const SizedBox(height: 35),

                _buildRepeatSelector(),

                const SizedBox(height: 45),
                if (isCustom) _buildRepeatOption(),

                const SizedBox(height: 20),

                _buildAlarmName(),

                const SizedBox(height: 35),

                _buildRingtone(),

                const SizedBox(height: 30),

                _buildSwitchTile(
                  title: 'Vibrate',
                  value: isVibrationEnabled,
                  onChanged: (value) {
                    setState(() {
                      isVibrationEnabled = value;
                    });
                  },
                ),

                const SizedBox(height: 20),

                _buildSwitchTile(
                  title: 'Snooze',
                  value: isSnoozeEnabled,
                  onChanged: (value) {
                    setState(() {
                      isSnoozeEnabled = value;
                    });
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12)
      ),
      height: 100,
      child: Row(
        children: [
          Expanded(
            child: CupertinoPicker(
              backgroundColor: Colors.transparent,
              selectionOverlay: const SizedBox(),
              squeeze: 1.2,
              itemExtent: 40,
              scrollController: FixedExtentScrollController(
                initialItem: hours.indexOf(selectedHour),
              ),
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedHour = hours[index];
                });
              },
              children: hours.map((hour) {
                return Center(
                  child: Text(
                    '$hour',
                    style: const TextStyle(fontSize: 22),
                  ),
                );
              }).toList(),
            ),
          ),

          const Text(
            'h',
            style: TextStyle(fontSize: 16),
          ),

          Expanded(
            child: CupertinoPicker(
              backgroundColor: Colors.transparent,
              selectionOverlay: const SizedBox(),
              itemExtent: 40,
              scrollController: FixedExtentScrollController(
                initialItem: selectedMinute,
              ),
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedMinute = minutes[index];
                });
              },
              children: minutes.map((minute) {
                return Center(
                  child: Text(
                    minute.toString().padLeft(2, '0'),
                    style: const TextStyle(fontSize: 22),
                  ),
                );
              }).toList(),
            ),
          ),

          const Text(
            'min',
            style: TextStyle(fontSize: 16),
          ),

          Expanded(
            child: CupertinoPicker(
              backgroundColor: Colors.transparent,
              selectionOverlay: const SizedBox(),
              itemExtent: 40,
              scrollController: FixedExtentScrollController(
                initialItem: isAm ? 0 : 1,
              ),
              onSelectedItemChanged: (index) {
                setState(() {
                  isAm = index == 0;
                });
              },
              children: const [
                Center(
                  child: Text(
                    'AM',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Center(
                  child: Text(
                    'PM',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildRepeatSelector() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isCustom = false;
              });
            },
            child: Container(
              height: 33,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: !isCustom ? Colors.black : Colors.grey[100],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'Ring once',
                style: TextStyle(
                  fontSize: 15,
                  color: !isCustom ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isCustom = true;
              });
            },
            child: Container(
              height: 33,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isCustom ? Colors.black : Colors.grey[100],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'Custom',
                style: TextStyle(
                  fontSize: 15,
                  color: isCustom ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRepeatOption() {
    return InkWell(
      onTap: () async {
        final result = await Navigator.push<List<String>>(
          context,
          MaterialPageRoute(
            builder: (_) => const AlarmRepeatScreen(),
          ),
        );

        if (result != null) {
          setState(() {
            selectedDays = result;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Repeat',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _formatSelectedDays(selectedDays),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(
                  Icons.chevron_right,
                  size: 30,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(
              color: Colors.black26,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
  String _formatSelectedDays(List<String> days) {
    if (days.isEmpty) return 'Select';
    if (days.length == 7) return 'Every day';

    const shortDays = {
      'Sunday': 'Sun',
      'Monday': 'Mon',
      'Tuesday': 'Tue',
      'Wednesday': 'Wed',
      'Thursday': 'Thu',
      'Friday': 'Fri',
      'Saturday': 'Sat',
    };

    return days.map((day) => shortDays[day] ?? day).join(', ');
  }
  Widget _buildAlarmName() {
    return TextField(
      controller: labelController,
      decoration: const InputDecoration(
        hintText: 'Alarm name',
        border: UnderlineInputBorder(),
      ),
    );
  }

  Widget _buildRingtone() {
    return InkWell(
      onTap: () {
        // Ringtone screen will be added later.
      },
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ringtone',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 5),
              const Text(
                'Default',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green,
                  fontWeight: FontWeight.w500
                ),
              ),
            ],
          ),

          const Spacer(),

          const Icon(
            Icons.chevron_right,
            size: 30,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Spacer(),
        Transform.scale(
          scale: 0.75,
          child: Switch(
            value: value,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }



  Future<void> _saveAlarm() async {
    final alarm = AlarmModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      hour: isAm
          ? (selectedHour == 12 ? 0 : selectedHour)
          : (selectedHour == 12 ? 12 : selectedHour + 12),
      minute: selectedMinute,
      isEnabled: true,
      label: labelController.text.trim().isEmpty
          ? 'Alarm'
          : labelController.text.trim(),
      repeatDays: isCustom ? selectedDays : ['Once'],
      isVibrationEnabled: isVibrationEnabled,
      ringtone: 'Default',
      snoozeMinutes: isSnoozeEnabled ? 5 : 0,
    );

    print('SAVE ALARM: ${alarm.id}');
    print('TIME: ${alarm.hour}:${alarm.minute}');
    print('REPEAT: ${alarm.repeatDays}');

    try {
      await context.read<AlarmProvider>().addAlarm(alarm);

      print('ALARM ADDED SUCCESSFULLY');

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e, stackTrace) {
      print('ALARM SAVE ERROR: $e');
      print(stackTrace);
    }
  }
}