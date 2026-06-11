import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'products_screen.dart';
import 'orders_screen.dart';
import 'statistics_screen.dart';

class PatissierScreen extends StatefulWidget {
  const PatissierScreen({super.key});

  @override
  State<PatissierScreen> createState() => _PatissierScreenState();
}

class _PatissierScreenState extends State<PatissierScreen> {
  String _shopName = '';
  String _email = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadPatissierData();
  }

  Future<void> _loadPatissierData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _shopName = prefs.getString('patissier_shop_name') ?? 'Mon Établissement';
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return DashboardContent(
          shopName: _shopName,
          email: _email,
        );
      case 1:
        return const PatissierProductsScreen();
      case 2:
        return const PatissierOrdersScreen();
      case 3:
        return const PatissierStatisticsScreen();
      case 4:
        return const SettingsContent();
      default:
        return DashboardContent(
          shopName: _shopName,
          email: _email,
        );
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
          "Espace Pâtissier",
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
      body: _getCurrentScreen(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF4A2C2A),
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Accueil",
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
              icon: Icon(Icons.bar_chart),
              label: "Statistiques",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Paramètres",
            ),
          ],
        ),
      ),
    );
  }
}

// Widget pour le tableau de bord
class DashboardContent extends StatelessWidget {
  final String shopName;
  final String email;

  const DashboardContent({
    super.key,
    required this.shopName,
    required this.email,
  });

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$feature - Bientôt disponible"),
        backgroundColor: const Color(0xFF4A2C2A),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToTab(BuildContext context, int index) {
    final patissierScreen = context.findAncestorStateOfType<_PatissierScreenState>();
    if (patissierScreen != null) {
      patissierScreen._onItemTapped(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                            shopName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            email,
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
                    _buildStatCard(Icons.shopping_bag, "156", "Commandes"),
                    _buildStatCard(Icons.pie_chart, "4", "Produits"),
                    _buildStatCard(Icons.star, "4.8", "Notes"),
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
                  _showComingSoon(context, "Ajout de produit");
                },
              ),
              _buildActionCard(
                icon: Icons.list_alt,
                title: "Mes produits",
                color: const Color(0xFF6B3A2A),
                onTap: () {
                  _navigateToTab(context, 1);
                },
              ),
              _buildActionCard(
                icon: Icons.receipt_long,
                title: "Commandes",
                color: const Color(0xFF8B5A3A),
                onTap: () {
                  _navigateToTab(context, 2);
                },
              ),
              _buildActionCard(
                icon: Icons.bar_chart,
                title: "Statistiques",
                color: const Color(0xFFA0826B),
                onTap: () {
                  _navigateToTab(context, 3);
                },
              ),
            ],
          ),

          const SizedBox(height: 25),

          // Commandes récentes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Commandes récentes",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2C2A),
                ),
              ),
              TextButton(
                onPressed: () {
                  _navigateToTab(context, 2);
                },
                child: const Text(
                  "Voir tout",
                  style: TextStyle(color: Color(0xFF4A2C2A)),
                ),
              ),
            ],
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
                "Aucune commande récente",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4A2C2A),
                ),
              ),
            ),
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
}

// Widget pour les paramètres
class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4A2C2A),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_patissier_logged', false);

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/role_choice');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8DADA),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.settings,
                    size: 50,
                    color: Color(0xFF4A2C2A),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Paramètres",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A2C2A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Gérez vos préférences",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            "Compte",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A2C2A),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            color: const Color(0xFFF8DADA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline, color: Color(0xFF4A2C2A)),
                  title: const Text("Profil"),
                  subtitle: const Text("Modifier vos informations"),
                  trailing: const Icon(Icons.chevron_right, color: Color(0xFF4A2C2A)),
                  onTap: () {
                    _showSnackBar(context, "Profil - Bientôt disponible");
                  },
                ),
                const Divider(indent: 60),
                ListTile(
                  leading: const Icon(Icons.lock_outline, color: Color(0xFF4A2C2A)),
                  title: const Text("Sécurité"),
                  subtitle: const Text("Changer votre mot de passe"),
                  trailing: const Icon(Icons.chevron_right, color: Color(0xFF4A2C2A)),
                  onTap: () {
                    _showSnackBar(context, "Sécurité - Bientôt disponible");
                  },
                ),
                const Divider(indent: 60),
                ListTile(
                  leading: const Icon(Icons.store_outlined, color: Color(0xFF4A2C2A)),
                  title: const Text("Informations établissement"),
                  subtitle: const Text("Modifier les infos de votre établissement"),
                  trailing: const Icon(Icons.chevron_right, color: Color(0xFF4A2C2A)),
                  onTap: () {
                    _showSnackBar(context, "Informations établissement - Bientôt disponible");
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            "Support",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A2C2A),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            color: const Color(0xFFF8DADA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.help_outline, color: Color(0xFF4A2C2A)),
                  title: const Text("Aide"),
                  subtitle: const Text("FAQ et assistance"),
                  trailing: const Icon(Icons.chevron_right, color: Color(0xFF4A2C2A)),
                  onTap: () {
                    _showSnackBar(context, "Aide - Bientôt disponible");
                  },
                ),
                const Divider(indent: 60),
                ListTile(
                  leading: const Icon(Icons.description_outlined, color: Color(0xFF4A2C2A)),
                  title: const Text("Conditions d'utilisation"),
                  trailing: const Icon(Icons.chevron_right, color: Color(0xFF4A2C2A)),
                  onTap: () {
                    _showSnackBar(context, "Conditions d'utilisation - Bientôt disponible");
                  },
                ),
                const Divider(indent: 60),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined, color: Color(0xFF4A2C2A)),
                  title: const Text("Confidentialité"),
                  trailing: const Icon(Icons.chevron_right, color: Color(0xFF4A2C2A)),
                  onTap: () {
                    _showSnackBar(context, "Confidentialité - Bientôt disponible");
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _logout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "Se déconnecter",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          const SizedBox(height: 30),

          Center(
            child: Text(
              "Version 1.0.0",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}