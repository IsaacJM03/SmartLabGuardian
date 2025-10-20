import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/dashboard_screen.dart';
import 'screens/alerts_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/history_screen.dart';
import 'providers/sensor_providers.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Lab Guardian',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    AlertsScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize auto-save and auto-logging
    // These providers will run in the background
    Future.microtask(() {
      ref.read(autoSaveHistoryProvider);
      ref.read(autoLogAlertsProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasAlerts = ref.watch(hasActiveAlertsProvider);

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: hasAlerts && _selectedIndex == 1
            ? Colors.red
            : Theme.of(context).colorScheme.primary,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: hasAlerts
                ? const Badge(
                    child: Icon(Icons.notifications),
                  )
                : const Icon(Icons.notifications),
            label: 'Alerts',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
