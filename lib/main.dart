import 'package:flutter/material.dart';
import 'views/onboarding/splash_screen.dart';

void main() {
  runApp(const BAKEEApp());
}

class BAKEEApp extends StatelessWidget {
  const BAKEEApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BAKEE',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'Arial',
      ),
      home: const SplashScreen(),
    );
  }
}