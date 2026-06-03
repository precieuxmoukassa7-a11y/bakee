import 'package:flutter/material.dart';
import 'onboarding3.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Page en blanc
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // 🛵 Carré pour l'icône de livraison
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
                    "assets/onboarding2.png",
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8DADA),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.delivery_dining,
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
                _dot(true),
                const SizedBox(width: 8),
                _dot(false),
              ],
            ),

            const SizedBox(height: 20),

            // 🧾 Titre
            const Text(
              "Livraison Rapide",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A2C2A), // Marron initial
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 10),

            // 💬 Description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Recevez vos pâtisseries fraîches et délicieuses directement chez vous en un rien de temps.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 👉 Bouton suivant (marron initial opaque)
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Onboarding3(),
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