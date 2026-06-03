import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'patissier_screen.dart';

class PatissierSignupScreen extends StatefulWidget {
  const PatissierSignupScreen({super.key});

  @override
  State<PatissierSignupScreen> createState() => _PatissierSignupScreenState();
}

class _PatissierSignupScreenState extends State<PatissierSignupScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _shopNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _taxNumberController = TextEditingController(); // Numéro d'identification fiscale

  // États
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _shopNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _taxNumberController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      _showSnackBar("Veuillez accepter les conditions d'utilisation", Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simuler un appel API
    await Future.delayed(const Duration(seconds: 2));

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('patissier_shop_name', _shopNameController.text.trim());
      await prefs.setString('patissier_email', _emailController.text.trim().toLowerCase());
      await prefs.setString('patissier_phone', _phoneController.text.trim());
      await prefs.setString('patissier_address', _addressController.text.trim());
      await prefs.setString('patissier_tax_number', _taxNumberController.text.trim());
      await prefs.setString('patissier_password', _passwordController.text);
      await prefs.setBool('is_patissier_logged', true);
      await prefs.setString('user_role', 'patissier');
      await prefs.setString('patissier_id', DateTime.now().millisecondsSinceEpoch.toString());

      if (mounted) {
        _showSnackBar("Compte pâtissier créé avec succès ! 🎉", Colors.green);

        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PatissierScreen()),
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar("Erreur lors de la création du compte", Colors.red);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Page en blanc
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8DADA), // Fond marron clair initial
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Color(0xFF4A2C2A), size: 20),
          ),
        ),
        title: const Text(
          "Espace Pâtissier",
          style: TextStyle(
            color: Color(0xFF4A2C2A),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icône et titre
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8DADA), // Fond marron clair initial
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.shade100,
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.bakery_dining,
                      size: 50,
                      color: Color(0xFF4A2C2A),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Créez votre boutique",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A2C2A),
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Rejoignez BAKEE en tant que pâtissier",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Formulaire
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Nom de la boutique
                  _buildTextField(
                    controller: _shopNameController,
                    label: "Nom de la boutique",
                    hint: "Ma Pâtisserie",
                    icon: Icons.store_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer le nom de votre boutique";
                      }
                      if (value.length < 3) {
                        return "Nom trop court";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Email
                  _buildTextField(
                    controller: _emailController,
                    label: "Email professionnel",
                    hint: "contact@mapatisserie.com",
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer votre email";
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return "Email invalide";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Téléphone
                  _buildTextField(
                    controller: _phoneController,
                    label: "Téléphone",
                    hint: "+33 6 12 34 56 78",
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer votre numéro";
                      }
                      final cleaned = value.replaceAll(RegExp(r'[^0-9+]'), '');
                      if (cleaned.length < 10) {
                        return "Numéro invalide (10 chiffres minimum)";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Adresse de la boutique
                  _buildTextField(
                    controller: _addressController,
                    label: "Adresse de la boutique",
                    hint: "12 rue des Pâtisseries, 75001 Paris",
                    icon: Icons.location_on_outlined,
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer votre adresse";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Numéro d'identification fiscale (optionnel)
                  _buildTextField(
                    controller: _taxNumberController,
                    label: "Numéro d'identification (optionnel)",
                    hint: "FR123456789",
                    icon: Icons.receipt_outlined,
                    validator: (value) => null,
                  ),

                  const SizedBox(height: 16),

                  // Mot de passe
                  _buildPasswordField(
                    controller: _passwordController,
                    label: "Mot de passe",
                    isVisible: _isPasswordVisible,
                    onVisibilityToggle: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer un mot de passe";
                      }
                      if (value.length < 6) {
                        return "Au moins 6 caractères";
                      }
                      if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
                        return "Doit contenir lettres et chiffres";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Confirmation mot de passe
                  _buildPasswordField(
                    controller: _confirmPasswordController,
                    label: "Confirmer le mot de passe",
                    isVisible: _isConfirmPasswordVisible,
                    onVisibilityToggle: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return "Les mots de passe ne correspondent pas";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Conditions d'utilisation
            Row(
              children: [
                Checkbox(
                  value: _acceptTerms,
                  onChanged: (value) {
                    setState(() {
                      _acceptTerms = value ?? false;
                    });
                  },
                  activeColor: const Color(0xFF4A2C2A),
                  checkColor: Colors.white,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _acceptTerms = !_acceptTerms;
                      });
                    },
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 13, color: Colors.black54),
                        children: [
                          const TextSpan(text: "J'accepte les "),
                          TextSpan(
                            text: "conditions d'utilisation",
                            style: const TextStyle(
                              color: Color(0xFF4A2C2A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(text: " et la "),
                          TextSpan(
                            text: "charte du pâtissier",
                            style: const TextStyle(
                              color: Color(0xFF4A2C2A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Bouton créer un compte
            _isLoading
                ? const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(color: Color(0xFF4A2C2A)),
                  SizedBox(height: 10),
                  Text("Création en cours...", style: TextStyle(color: Colors.black54)),
                ],
              ),
            )
                : ElevatedButton(
              onPressed: _createAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A2C2A),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
              ),
              child: const Text(
                "Créer mon compte pâtissier",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 20),

            // Séparateur
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey.shade300)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text("OU", style: TextStyle(color: Colors.grey.shade500)),
                ),
                Expanded(child: Divider(color: Colors.grey.shade300)),
              ],
            ),

            const SizedBox(height: 20),

            // Lien vers connexion
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Déjà un compte ? ", style: TextStyle(fontSize: 14)),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF4A2C2A),
                  ),
                  child: const Text(
                    "Se connecter",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: false,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF4A2C2A)),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        prefixIcon: Icon(icon, color: const Color(0xFF4A2C2A)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4A2C2A), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      validator: validator,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF4A2C2A)),
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF4A2C2A)),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey.shade500,
          ),
          onPressed: onVisibilityToggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4A2C2A), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
    );
  }
}