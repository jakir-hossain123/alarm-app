import 'package:flutter/material.dart';

class AlarmRepeatScreen extends StatefulWidget {
  const AlarmRepeatScreen({super.key});

  @override
  State<AlarmRepeatScreen> createState() => _AlarmRepeatScreenState();
}

class _AlarmRepeatScreenState extends State<AlarmRepeatScreen> {
  final List<String> _repeatedDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  final Set<String> selectedDays = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context,
              selectedDays.toList(),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('Repeat',style: Theme.of(context).textTheme.titleMedium,),
      ),

      body: ListView.builder(
         itemCount: _repeatedDays.length,
         itemBuilder: ( context,  index) {
          final day = _repeatedDays[index];
          final isSelected = selectedDays.contains(day);

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            title: Text(
              'Every $day',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400,fontSize: 15)
            ),
            trailing: Checkbox(
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    selectedDays.add(day);
                  } else {
                    selectedDays.remove(day);
                  }
                });
              },
              shape: const CircleBorder(),
            ),
          );

         },

      ),

    );
  }
}
