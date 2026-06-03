import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../role_choice_screen.dart';
import 'cart_screen.dart';
import 'order_screen.dart';
import 'profile_screen.dart';
import 'favorites_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _cartCount = 0;

  // Paramètres utilisateur
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'Français';
  String _selectedCurrency = 'FCFA';

  @override
  void initState() {
    super.initState();
    _loadCartCount();
    _loadSettings();
  }

  Future<void> _loadCartCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? cartJson = prefs.getString('cart');

      if (cartJson != null && cartJson.isNotEmpty && cartJson != 'null' && cartJson != '[]') {
        final decoded = jsonDecode(cartJson);
        if (decoded is List) {
          int count = 0;
          for (var item in decoded) {
            if (item is Map) {
              count += (item['quantity'] ?? 0) as int;
            }
          }
          setState(() {
            _cartCount = count;
          });
        }
      } else {
        setState(() {
          _cartCount = 0;
        });
      }
    } catch (e) {
      setState(() {
        _cartCount = 0;
      });
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _soundEnabled = prefs.getBool('sound') ?? true;
      _darkModeEnabled = prefs.getBool('darkMode') ?? false;
      _selectedLanguage = prefs.getString('language') ?? 'Français';
      _selectedCurrency = prefs.getString('currency') ?? 'FCFA';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', _notificationsEnabled);
    await prefs.setBool('sound', _soundEnabled);
    await prefs.setBool('darkMode', _darkModeEnabled);
    await prefs.setString('language', _selectedLanguage);
    await prefs.setString('currency', _selectedCurrency);
  }

  Future<void> _logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Déconnexion"),
        content: const Text("Êtes-vous sûr de vouloir vous déconnecter ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const RoleChoiceScreen()),
                );
              }
            },
            child: const Text("Se déconnecter", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _clearCart() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Vider le panier"),
        content: const Text("Êtes-vous sûr de vouloir vider votre panier ? Cette action est irréversible."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('cart');
              _loadCartCount();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Panier vidé avec succès"),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text("Vider", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _clearHistory() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Effacer l'historique"),
        content: const Text("Êtes-vous sûr de vouloir effacer tout l'historique des commandes ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('orders');
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Historique effacé"),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text("Effacer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("À propos"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cake, size: 60, color: Color(0xFF4A2C2A)),
            const SizedBox(height: 10),
            const Text(
              "BAKEE",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A2C2A),
              ),
            ),
            const SizedBox(height: 5),
            const Text("Version 1.0.0"),
            const SizedBox(height: 10),
            const Text(
              "Votre application de vente de pâtisseries en ligne",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 5),
            const Text("© 2024 BAKEE. Tous droits réservés."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fermer"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Paramètres",
          style: TextStyle(
            color: Color(0xFF4A2C2A),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                  _loadCartCount();
                },
                icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF4A2C2A)),
              ),
              if (_cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                    child: Text(
                      '$_cartCount',
                      style: const TextStyle(color: Colors.white, fontSize: 8),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          // Section Profil
          _buildSectionHeader("Compte", Icons.person),
          _buildProfileTile(),

          // Section Préférences
          _buildSectionHeader("Préférences", Icons.settings),
          _buildSwitchTile(
            icon: Icons.notifications,
            title: "Notifications",
            subtitle: "Recevoir les alertes et offres",
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
                _saveSettings();
              });
            },
          ),
          _buildSwitchTile(
            icon: Icons.volume_up,
            title: "Sons",
            subtitle: "Activer les sons de l'application",
            value: _soundEnabled,
            onChanged: (value) {
              setState(() {
                _soundEnabled = value;
                _saveSettings();
              });
            },
          ),
          _buildSwitchTile(
            icon: Icons.dark_mode,
            title: "Mode sombre",
            subtitle: "Thème sombre pour l'application",
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
                _saveSettings();
              });
            },
          ),
          _buildDropdownTile(
            icon: Icons.language,
            title: "Langue",
            subtitle: "Changer la langue de l'application",
            value: _selectedLanguage,
            items: const ['Français', 'English', 'Español'],
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value!;
                _saveSettings();
              });
            },
          ),
          _buildDropdownTile(
            icon: Icons.attach_money,
            title: "Devise",
            subtitle: "Changer la devise d'affichage",
            value: _selectedCurrency,
            items: const ['FCFA', 'EUR', 'USD'],
            onChanged: (value) {
              setState(() {
                _selectedCurrency = value!;
                _saveSettings();
              });
            },
          ),

          // Section Données
          _buildSectionHeader("Données", Icons.data_usage),
          _buildActionTile(
            icon: Icons.delete_sweep,
            title: "Vider le panier",
            subtitle: "Supprimer tous les articles du panier",
            color: Colors.orange,
            onTap: _clearCart,
          ),
          _buildActionTile(
            icon: Icons.history,
            title: "Effacer l'historique",
            subtitle: "Supprimer tout l'historique des commandes",
            color: Colors.red,
            onTap: _clearHistory,
          ),

          // Section Support
          _buildSectionHeader("Support", Icons.support_agent),
          _buildNavigationTile(
            icon: Icons.favorite,
            title: "Mes favoris",
            subtitle: "Voir vos produits favoris",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
          ),
          _buildNavigationTile(
            icon: Icons.receipt,
            title: "Mes commandes",
            subtitle: "Voir l'historique de vos commandes",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OrderScreen()),
              );
            },
          ),
          _buildNavigationTile(
            icon: Icons.person,
            title: "Mon profil",
            subtitle: "Modifier vos informations personnelles",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          _buildNavigationTile(
            icon: Icons.help,
            title: "Aide",
            subtitle: "FAQ et assistance",
            onTap: () {
              _showHelpDialog();
            },
          ),
          _buildNavigationTile(
            icon: Icons.info,
            title: "À propos",
            subtitle: "Informations sur l'application",
            onTap: _showAboutDialog,
          ),

          // Section Déconnexion
          const SizedBox(height: 20),
          _buildLogoutTile(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF4A2C2A)),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A2C2A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTile() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF4A2C2A),
          child: const Icon(Icons.person, color: Colors.white),
        ),
        title: const Text("Jean Dupont"),
        subtitle: const Text("jean.dupont@email.com"),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          );
        },
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SwitchListTile(
        secondary: Icon(icon, color: const Color(0xFF4A2C2A)),
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF4A2C2A),
      ),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF4A2C2A)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: DropdownButton<String>(
          value: value,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          underline: const SizedBox(),
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF4A2C2A)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutTile() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text(
          "Se déconnecter",
          style: TextStyle(color: Colors.red),
        ),
        subtitle: const Text("Quitter votre compte"),
        trailing: const Icon(Icons.chevron_right, color: Colors.red),
        onTap: () => _logout(context),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Aide et assistance"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpItem("Comment passer une commande ?",
                "1. Ajoutez des produits au panier\n"
                    "2. Allez dans l'onglet Commande\n"
                    "3. Validez votre commande\n"
                    "4. Entrez vos informations de livraison"),
            const SizedBox(height: 10),
            _buildHelpItem("Comment contacter le support ?",
                "Email: support@bakee.com\n"
                    "Téléphone: +237 6 XX XX XX XX"),
            const SizedBox(height: 10),
            _buildHelpItem("Délai de livraison ?",
                "La livraison prend généralement entre 30 minutes et 1 heure selon votre localisation."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fermer"),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          content,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}