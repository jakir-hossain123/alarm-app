import 'package:alarm_app/presentasion/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
import '../widgets/app_bottom_nav_bar.dart';
import 'alarm_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final  currentIndex = context.watch<NavigationProvider>().currentIndex;

    return Scaffold(
      body: _buildCurrentScreen(currentIndex),
      bottomNavigationBar: const AppBottomNavBar()
    );
  }

  Widget _buildCurrentScreen(int currentIndex){
    switch(currentIndex){
      case 0:
      return AlarmScreen();

      case 1:
        return Center(
            child: Text("World Clock will be implemented later.")
        );

      case 2:
        return Center(
            child: Text("Stop Watch will be implemented later.")
        );

      case 3:
        return Center(
            child: Text("Timer will be implemented later.")
        );
      default: return AlarmScreen();
    }
  }
}
