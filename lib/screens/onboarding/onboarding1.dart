import 'package:flutter/material.dart';
import 'onboarding2.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // 🧁 Carré pour l'icône du gâteau
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8DADA),
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
                    "assets/onboarding1.png",
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8DADA),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.cake,
                          size: 120,
                          color: Color(0xFF4A2C2A),
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
                _dot(true),
                const SizedBox(width: 8),
                _dot(false),
                const SizedBox(width: 8),
                _dot(false),
              ],
            ),

            const SizedBox(height: 20),

            // 🧾 Titre (centré)
            const Text(
              "Bienvenue sur BAKEE",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A2C2A),
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 10),

            // 💬 Description (centrée)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Découvrez les meilleures pâtisseries près de chez vous et commandez facilement.",
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

            // 👉 Bouton suivant (plus bas)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A2C2A),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  // Navigation vers onboarding2
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Onboarding2(),
                    ),
                  );
                },
                child: const Text(
                  "Suivant",
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

  // 🔘 Widget pour les points
  Widget _dot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: isActive ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF4A2C2A) : Colors.grey.shade300,
        borderRadius: isActive ? BorderRadius.circular(4) : null,
        shape: isActive ? BoxShape.rectangle : BoxShape.circle,
      ),
    );
  }
}