import 'package:flutter/material.dart';
import 'onboarding/auth/signup_screen.dart';
import 'patissier/patissier_signup_screen.dart';

class RoleChoiceScreen extends StatelessWidget {
  const RoleChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Page en blanc
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Logo
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8DADA), // Fond marron clair initial
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.cake, size: 60, color: Color(0xFF4A2C2A)), // Marron initial
              ),

              const SizedBox(height: 30),

              const Text(
                "Bienvenue sur BAKEE",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2C2A), // Marron initial
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Choisissez votre profil",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 50),

              // Option Client → Création de compte
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupScreen()),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A2C2A), // Marron initial opaque
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Carré blanc pour l'icône
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white, // Fond blanc
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.shopping_bag_outlined, size: 30, color: Color(0xFF4A2C2A)), // Marron initial
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Je suis un client",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // Texte blanc
                            ),
                            Text(
                              "Commandez de délicieuses pâtisseries",
                              style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.8)), // Texte blanc transparent
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white.withOpacity(0.8)), // Flèche blanche
                    ],
                  ),
                ),
              ),

              // Option Pâtissier
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PatissierSignupScreen()),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A2C2A), // Marron initial opaque
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Carré blanc pour l'icône
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white, // Fond blanc
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.bakery_dining_outlined, size: 30, color: Color(0xFF4A2C2A)), // Marron initial
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Je suis un pâtissier",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // Texte blanc
                            ),
                            Text(
                              "Gérez vos produits et commandes",
                              style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.8)), // Texte blanc transparent
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white.withOpacity(0.8)), // Flèche blanche
                    ],
                  ),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}