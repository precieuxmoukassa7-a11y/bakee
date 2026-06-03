import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../role_choice_screen.dart';
import 'edit_profile_screen.dart';
import 'orders_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = "";
  String _userEmail = "";
  String _userPhone = "";
  String _userAddress = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _userName = prefs.getString('user_name') ?? "Non renseigné";
      _userEmail = prefs.getString('user_email') ?? "Non renseigné";
      _userPhone = prefs.getString('user_phone') ?? "Non renseigné";
      _userAddress = prefs.getString('user_address') ?? "Non renseigné";
      _isLoading = false;
    });
  }

  Future<void> _logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Déconnexion"),
        content: const Text("Êtes-vous sûr de vouloir vous déconnecter ?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler", style: TextStyle(color: Colors.grey)),
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
            child: const Text("Déconnecter", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDECEC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDECEC),
        elevation: 0,
        title: const Text(
          "Mon profil",
          style: TextStyle(
            color: Color(0xFF4A2C2A),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A2C2A)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout, color: Color(0xFF4A2C2A)),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Color(0xFF4A2C2A)),
      )
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Avatar
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: const Color(0xFF4A2C2A),
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Nom
            Text(
              _userName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A2C2A),
              ),
            ),

            const SizedBox(height: 40),

            // Informations
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Email
                  _buildInfoTile(
                    icon: Icons.email_outlined,
                    label: "Email",
                    value: _userEmail,
                  ),
                  const Divider(height: 1, indent: 60, endIndent: 20),

                  // Téléphone
                  _buildInfoTile(
                    icon: Icons.phone_outlined,
                    label: "Téléphone",
                    value: _userPhone,
                  ),
                  const Divider(height: 1, indent: 60, endIndent: 20),

                  // Adresse
                  _buildInfoTile(
                    icon: Icons.location_on_outlined,
                    label: "Adresse",
                    value: _userAddress,
                  ),
                  const Divider(height: 1, indent: 60, endIndent: 20),

                  // Membre depuis
                  _buildInfoTile(
                    icon: Icons.cake_outlined,
                    label: "Membre depuis",
                    value: "2024",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Boutons d'action
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Modifier le profil
                  _buildActionButton(
                    icon: Icons.edit_outlined,
                    label: "Modifier mon profil",
                    color: const Color(0xFF4A2C2A),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                      );
                      _loadUserData(); // Recharger les données
                      _showSnackBar("Profil mis à jour", Colors.green);
                    },
                  ),

                  const SizedBox(height: 15),

                  // Mes commandes
                  _buildActionButton(
                    icon: Icons.shopping_bag_outlined,
                    label: "Mes commandes",
                    color: const Color(0xFFFF9800),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OrdersScreen()),
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  // Historique
                  _buildActionButton(
                    icon: Icons.history_outlined,
                    label: "Historique",
                    color: const Color(0xFF795548),
                    onTap: () {
                      _showSnackBar("Historique en cours de développement", Colors.orange);
                    },
                  ),

                  const SizedBox(height: 15),

                  // Aide
                  _buildActionButton(
                    icon: Icons.help_outline,
                    label: "Aide",
                    color: const Color(0xFF9C27B0),
                    onTap: () {
                      _showSnackBar("Aide en cours de développement", Colors.orange);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Version
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                "Version 1.0.0",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, size: 24, color: const Color(0xFF4A2C2A)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4A2C2A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}