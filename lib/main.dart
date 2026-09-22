import 'package:flutter/material.dart';

import 'screens/home_page.dart';
import 'screens/schedule_page.dart';
import 'screens/task_page.dart';
import 'screens/settings_page.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.instance.initialize();

  await NotificationService.instance.requestPermission();

  runApp(
    const SchedulePlannerApp(),
  );
}

class SchedulePlannerApp
    extends StatelessWidget {
  const SchedulePlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Schedule Planner',

      theme: ThemeData(
        useMaterial3: true,

        colorScheme:
            ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),

        scaffoldBackgroundColor:
            const Color(0xFFF7F8FC),
      ),

      home: const MainScreen(),
    );
  }
}

class MainScreen
    extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() =>
      _MainScreenState();
}

class _MainScreenState
    extends State<MainScreen> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    SchedulePage(),
    TaskPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar:
          NavigationBar(
        selectedIndex: currentIndex,

        onDestinationSelected:
            (index) {
          setState(() {
            currentIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
            ),
            selectedIcon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.calendar_month_outlined,
            ),
            selectedIcon: Icon(
              Icons.calendar_month,
            ),
            label: 'Schedule',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.check_circle_outline,
            ),
            selectedIcon: Icon(
              Icons.check_circle,
            ),
            label: 'Task',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.settings_outlined,
            ),
            selectedIcon: Icon(
              Icons.settings,
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}