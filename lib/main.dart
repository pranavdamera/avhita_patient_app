import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'features/onboarding/screens/onboarding_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const AvhitaPatientApp());
}

class AvhitaPatientApp extends StatelessWidget {
  const AvhitaPatientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avhita Patient',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // First launch → Onboarding. After completion, navigates to AppShell.
      // In production, check SharedPreferences for onboarding completion.
      home: const OnboardingScreen(),
    );
  }
}
