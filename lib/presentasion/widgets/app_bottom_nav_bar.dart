import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return  Theme(
    data: Theme.of(context).copyWith(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent
    ),
    child:
      BottomNavigationBar(
        backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey[500],
          type: BottomNavigationBarType.fixed,
          currentIndex: context.watch<NavigationProvider>().currentIndex,
        onTap: (ind){
          context.read<NavigationProvider>().changeIndex(ind);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: "Alarm"),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: "World Clock"),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: "Stop Watch"),
          BottomNavigationBarItem(icon: Icon(Icons.hourglass_bottom_outlined), label: "Timer"),
        ]
      )
    );
  }
}
