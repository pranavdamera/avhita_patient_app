import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme.dart';
import '../features/home/screens/home_screen.dart';
import '../features/health/screens/health_screen.dart';
import '../features/reports/screens/reports_screen.dart';
import '../features/doctor/screens/doctor_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../widgets/widgets.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    HealthScreen(),
    ReportsScreen(),
    DoctorScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 16, offset: const Offset(0, -4))],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: BottomNavigationBar(
              currentIndex: _index,
              onTap: (i) { if (i != _index) { HapticFeedback.selectionClick(); setState(() => _index = i); } },
              items: [
                const BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.favorite_rounded),
                  activeIcon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.favorite_rounded),
                      Positioned(right: -2, top: -2, child: PulsingDot(size: 6, color: AppColors.green)),
                    ],
                  ),
                  label: 'Health',
                ),
                const BottomNavigationBarItem(icon: Icon(Icons.description_rounded), label: 'Reports'),
                const BottomNavigationBarItem(icon: Icon(Icons.medical_services_rounded), label: 'Doctor'),
                const BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
