import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding/onboarding1.dart';
import 'role_choice_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    await Future.delayed(const Duration(seconds: 3)); // Attendre 3 secondes

    final prefs = await SharedPreferences.getInstance();
    bool hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;

    if (hasSeenOnboarding) {
      // Si déjà vu onboarding, aller directement au choix du rôle
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RoleChoiceScreen()),
        );
      }
    } else {
      // Première fois, afficher l'onboarding
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Onboarding1()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDECEC), // fond rose clair
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFF8DADA),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🍰 Logo
              Image.asset(
                'assets/logo.png', // mets ton logo ici
                height: 80,
              ),
              const SizedBox(height: 20),

              // 🧁 Titre
              const Text(
                "BAKEE",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2C2A),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),

              // 💬 Slogan
              const Text(
                "Vos douceurs, livrées\navec amour 💚",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),

              // 🧁 Image cupcakes
              Image.asset(
                'assets/cupcakes.png',
                height: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}