import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding/onboarding1.dart';
import 'screens/role_choice_screen.dart';
import 'screens/client/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bakee - Pâtisserie en ligne',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'Poppins', // si tu as une police personnalisée
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
      routes: {
        '/onboarding1': (context) => const Onboarding1(),
        '/roleChoice': (context) => const RoleChoiceScreen(),
        '/clientHome': (context) => const HomeScreen(),
      },
    );
  }
}