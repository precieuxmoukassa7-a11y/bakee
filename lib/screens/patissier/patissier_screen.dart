import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatissierScreen extends StatefulWidget {
  const PatissierScreen({super.key});

  @override
  State<PatissierScreen> createState() => _PatissierScreenState();
}

class _PatissierScreenState extends State<PatissierScreen> {
  String _shopName = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadPatissierData();
  }

  Future<void> _loadPatissierData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _shopName = prefs.getString('patissier_shop_name') ?? 'Ma Boutique';
      _email = prefs.getString('patissier_email') ?? 'email@example.com';
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_patissier_logged', false);

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/role_choice');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A2C2A),
        elevation: 0,
        title: const Text(
          "Tableau de bord",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carte de bienvenue
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF4A2C2A),
                    const Color(0xFF6B3A2A),
                  ],
                ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.bakery_dining,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _shopName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              _email,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(Icons.shopping_bag, "0", "Commandes"),
                      _buildStatCard(Icons.pie_chart, "0", "Produits"),
                      _buildStatCard(Icons.star, "0", "Notes"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Actions rapides
            const Text(
              "Actions rapides",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A2C2A),
              ),
            ),
            const SizedBox(height: 15),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                _buildActionCard(
                  icon: Icons.add_shopping_cart,
                  title: "Ajouter un produit",
                  color: const Color(0xFF4A2C2A),
                  onTap: () {
                    // Naviguer vers ajout produit
                    _showComingSoon("Ajout de produit");
                  },
                ),
                _buildActionCard(
                  icon: Icons.list_alt,
                  title: "Mes produits",
                  color: const Color(0xFF6B3A2A),
                  onTap: () {
                    _showComingSoon("Liste des produits");
                  },
                ),
                _buildActionCard(
                  icon: Icons.receipt_long,
                  title: "Commandes",
                  color: const Color(0xFF8B5A3A),
                  onTap: () {
                    _showComingSoon("Gestion des commandes");
                  },
                ),
                _buildActionCard(
                  icon: Icons.bar_chart,
                  title: "Statistiques",
                  color: const Color(0xFFA0826B),
                  onTap: () {
                    _showComingSoon("Statistiques");
                  },
                ),
              ],
            ),

            const SizedBox(height: 25),

            // Dernières commandes
            const Text(
              "Dernières commandes",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A2C2A),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8DADA),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Text(
                  "Aucune commande pour le moment",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4A2C2A),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF4A2C2A),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Tableau de bord",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "Produits",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: "Commandes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.white),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 35, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$feature - Bientôt disponible"),
        backgroundColor: const Color(0xFF4A2C2A),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}