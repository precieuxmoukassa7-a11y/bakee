import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'patissier_dashboard_screen.dart';
import '../../role_choice_screen.dart';

class PatissierScreen extends StatefulWidget {
  const PatissierScreen({super.key});

  @override
  State<PatissierScreen> createState() => _PatissierLoginScreenState();
}

class _PatissierLoginScreenState extends State<PatissierScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  // Identifiants par défaut (à remplacer par une API)
  final String _defaultEmail = "patissier@bakee.com";
  final String _defaultPassword = "123456";

  Future<void> _login() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      _showSnackBar("Veuillez remplir tous les champs", Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (_emailController.text.trim() == _defaultEmail &&
        _passwordController.text == _defaultPassword) {

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_patissier_logged', true);
      await prefs.setString('patissier_email', _emailController.text.trim());
      await prefs.setString('user_role', 'patissier');

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PatissierScreen()),
        );
      }
    } else {
      _showSnackBar("Email ou mot de passe incorrect", Colors.red);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDECEC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8DADA),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bakery_dining,
                  size: 60,
                  color: Color(0xFF4A2C2A),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Espace Pâtissier",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2C2A),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Connectez-vous à votre espace",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 40),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "patissier@bakee.com",
                  prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF4A2C2A)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Mot de passe",
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF4A2C2A)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              const SizedBox(height: 30),

              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF4A2C2A)))
                  : ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A2C2A),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Se connecter",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Vous n'avez pas de compte ? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Créer un compte",
                      style: TextStyle(color: Color(0xFF4A2C2A), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}