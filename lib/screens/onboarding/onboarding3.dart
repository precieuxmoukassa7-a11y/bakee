import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../role_choice_screen.dart';

class Onboarding3 extends StatelessWidget {
  const Onboarding3({super.key});

  Future<void> _completeOnboarding(BuildContext context) async {
    // Sauvegarder que l'utilisateur a vu l'onboarding
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);

    // Rediriger vers l'écran de choix du rôle
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RoleChoiceScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Page en blanc
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // 💳 Carré pour l'icône de paiement
            Center(
              child: Container(
                width: 200,  // Largeur fixe du carré
                height: 200, // Hauteur fixe du carré
                decoration: BoxDecoration(
                  color: const Color(0xFFF8DADA), // Fond marron clair initial
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "assets/onboarding3.png",
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8DADA),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.payment,
                          size: 120,
                          color: Color(0xFF4A2C2A), // Marron initial
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 📍 Indicateur de page
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _dot(false),
                const SizedBox(width: 8),
                _dot(false),
                const SizedBox(width: 8),
                _dot(true),
              ],
            ),

            const SizedBox(height: 20),

            // 🧾 Titre (centré)
            const Text(
              "Paiement Sécurisé",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A2C2A), // Marron initial
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 10),

            // 💬 Description (centrée)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Commandez en toute sérénité avec notre système de paiement 100% sécurisé.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ),

            // 🔥 Utilisation de Spacer() pour pousser le bouton vers le bas
            const Spacer(),

            // 👉 Bouton commencer (plus bas)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A2C2A), // Marron initial opaque
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 2,
                ),
                onPressed: () => _completeOnboarding(context),
                child: const Text(
                  "Commencer",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _dot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: isActive ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF4A2C2A) : Colors.grey.shade300, // Marron initial pour le point actif
        borderRadius: isActive ? BorderRadius.circular(4) : null,
        shape: isActive ? BoxShape.rectangle : BoxShape.circle,
      ),
    );
  }
}