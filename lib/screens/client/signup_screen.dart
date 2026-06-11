import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../client/home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // États
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _acceptTerms = false;

  // Focus nodes
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _addressFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
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
      await prefs.setString('user_first_name', _firstNameController.text.trim());
      await prefs.setString('user_last_name', _lastNameController.text.trim());
      await prefs.setString('user_email', _emailController.text.trim().toLowerCase());
      await prefs.setString('user_phone', _phoneController.text.trim());
      await prefs.setString('user_address', _addressController.text.trim());
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('user_role', 'client');
      await prefs.setString('user_id', DateTime.now().millisecondsSinceEpoch.toString());

      if (mounted) {
        _showSnackBar("Compte créé avec succès ! 🎉", Colors.green);

        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
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

  bool _validateCurrentStep() {
    if (_currentStep == 0) {
      if (_firstNameController.text.trim().isEmpty || _lastNameController.text.trim().isEmpty) {
        _showSnackBar("Veuillez remplir tous les champs", Colors.red);
        return false;
      }
      if (_firstNameController.text.trim().length < 2) {
        _showSnackBar("Le prénom est trop court", Colors.red);
        return false;
      }
      if (_lastNameController.text.trim().length < 2) {
        _showSnackBar("Le nom est trop court", Colors.red);
        return false;
      }
      return true;
    }

    if (_currentStep == 1) {
      // Email validation
      String email = _emailController.text.trim();
      if (email.isEmpty) {
        _showSnackBar("Veuillez entrer votre email", Colors.red);
        return false;
      }
      if (!email.contains('@') || !email.contains('.')) {
        _showSnackBar("Email invalide", Colors.red);
        return false;
      }

      // Phone validation
      String phone = _phoneController.text.trim();
      if (phone.isEmpty) {
        _showSnackBar("Veuillez entrer votre numéro de téléphone", Colors.red);
        return false;
      }
      final cleaned = phone.replaceAll(RegExp(r'[^0-9+]'), '');
      if (cleaned.length < 10) {
        _showSnackBar("Numéro invalide (10 chiffres minimum)", Colors.red);
        return false;
      }

      // Address validation
      if (_addressController.text.trim().isEmpty) {
        _showSnackBar("Veuillez entrer votre adresse", Colors.red);
        return false;
      }
      return true;
    }

    if (_currentStep == 2) {
      String password = _passwordController.text;
      if (password.isEmpty) {
        _showSnackBar("Veuillez entrer un mot de passe", Colors.red);
        return false;
      }
      if (password.length < 6) {
        _showSnackBar("Le mot de passe doit contenir au moins 6 caractères", Colors.red);
        return false;
      }
      if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(password)) {
        _showSnackBar("Le mot de passe doit contenir lettres et chiffres", Colors.red);
        return false;
      }
      if (_confirmPasswordController.text != password) {
        _showSnackBar("Les mots de passe ne correspondent pas", Colors.red);
        return false;
      }
      return true;
    }

    return true;
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      setState(() {
        if (_currentStep < 3) {
          _currentStep++;
        }
      });
    }
  }

  void _previousStep() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
    });
  }

  // Dialogue des conditions d'utilisation
  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxHeight: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Conditions d'utilisation",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A2C2A),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Color(0xFF4A2C2A)),
                    ),
                  ],
                ),
                const Divider(color: Color(0xFF4A2C2A)),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _termsSection(
                          "1. Acceptation des conditions",
                          "En utilisant l'application BAKEE, vous acceptez d'être lié par ces conditions d'utilisation.",
                        ),
                        const SizedBox(height: 16),
                        _termsSection(
                          "2. Commandes",
                          "Les commandes passées sur BAKEE sont fermes et définitives. Le paiement doit être effectué au moment de la commande.",
                        ),
                        const SizedBox(height: 16),
                        _termsSection(
                          "3. Livraison",
                          "Les délais de livraison sont donnés à titre indicatif. En cas de retard, nous vous tiendrons informé.",
                        ),
                        const SizedBox(height: 16),
                        _termsSection(
                          "4. Annulation",
                          "Vous pouvez annuler votre commande dans les 5 minutes suivant sa validation. Passé ce délai, veuillez contacter le pâtissier.",
                        ),
                        const SizedBox(height: 16),
                        _termsSection(
                          "5. Remboursement",
                          "En cas de problème avec votre commande, contactez notre service client sous 24h.",
                        ),
                        const SizedBox(height: 16),
                        _termsSection(
                          "6. Protection des données",
                          "Vos données personnelles sont collectées uniquement pour le traitement de vos commandes.",
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A2C2A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("J'ai compris"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Dialogue de la politique de confidentialité
  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxHeight: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Politique de confidentialité",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A2C2A),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Color(0xFF4A2C2A)),
                    ),
                  ],
                ),
                const Divider(color: Color(0xFF4A2C2A)),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _termsSection(
                          "Données collectées",
                          "Nous collectons votre nom, email, téléphone et adresse pour traiter vos commandes.",
                        ),
                        const SizedBox(height: 16),
                        _termsSection(
                          "Utilisation des données",
                          "Vos données sont utilisées uniquement pour la livraison de vos commandes et la communication liée à votre compte.",
                        ),
                        const SizedBox(height: 16),
                        _termsSection(
                          "Partage des données",
                          "Vos données sont partagées uniquement avec les pâtissiers pour la préparation de vos commandes.",
                        ),
                        const SizedBox(height: 16),
                        _termsSection(
                          "Sécurité",
                          "Nous mettons en œuvre des mesures de sécurité pour protéger vos données personnelles.",
                        ),
                        const SizedBox(height: 16),
                        _termsSection(
                          "Vos droits",
                          "Vous pouvez modifier ou supprimer vos informations à tout moment depuis votre profil.",
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A2C2A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("J'ai compris"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget pour une section dans les conditions
  Widget _termsSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A2C2A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8DADA),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Color(0xFF4A2C2A), size: 20),
          ),
        ),
        title: const Text(
          "Créer un compte",
          style: TextStyle(
            color: Color(0xFF4A2C2A),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Contenu de l'étape
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(24),
              child: _buildCurrentStep(),
            ),
          ),

          // Boutons suivant/précédent
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF4A2C2A),
                        side: const BorderSide(color: Color(0xFF4A2C2A)),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text("Précédent", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  child: _isLoading && _currentStep == 3
                      ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF4A2C2A)),
                  )
                      : ElevatedButton(
                    onPressed: _currentStep < 3 ? _nextStep : _createAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A2C2A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      _currentStep < 3 ? "Suivant" : "Créer mon compte",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      case 3:
        return _buildStep4();
      default:
        return _buildStep1();
    }
  }

  // Étape 1: Nom et prénom (avec lien de connexion)
  Widget _buildStep1() {
    return Column(
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.shade100,
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_add_alt_rounded,
                  size: 50,
                  color: Color(0xFF4A2C2A),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Quel est votre nom ?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2C2A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Entrez vos informations d'identité",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        _buildTextField(
          controller: _firstNameController,
          focusNode: _firstNameFocus,
          label: "Prénom",
          hint: "Jean",
          icon: Icons.person_outline,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => _lastNameFocus.requestFocus(),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _lastNameController,
          focusNode: _lastNameFocus,
          label: "Nom",
          hint: "Dupont",
          icon: Icons.person_outline,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _nextStep(),
        ),
        // 🔥 NOUVEAU : Lien de connexion
        const SizedBox(height: 24),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Vous avez déjà un compte ? ",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              GestureDetector(
                onTap: () {
                  // Retourner à l'écran de choix du rôle pour se connecter
                  Navigator.pop(context);
                },
                child: const Text(
                  "Se connecter",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A2C2A),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Étape 2: Email, téléphone et adresse
  Widget _buildStep2() {
    return Column(
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.shade100,
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.contact_mail_outlined,
                  size: 50,
                  color: Color(0xFF4A2C2A),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Comment vous contacter ?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2C2A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Entrez vos coordonnées",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        _buildTextField(
          controller: _emailController,
          focusNode: _emailFocus,
          label: "Email",
          hint: "jean.dupont@email.com",
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => _phoneFocus.requestFocus(),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _phoneController,
          focusNode: _phoneFocus,
          label: "Téléphone",
          hint: "+33 6 12 34 56 78",
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => _addressFocus.requestFocus(),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _addressController,
          focusNode: _addressFocus,
          label: "Adresse de livraison",
          hint: "12 rue des Pâtisseries, 75001 Paris",
          icon: Icons.location_on_outlined,
          textInputAction: TextInputAction.done,
          maxLines: 2,
          onSubmitted: (_) => _nextStep(),
        ),
      ],
    );
  }

  // Étape 3: Mot de passe et confirmation
  Widget _buildStep3() {
    return Column(
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.shade100,
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.lock_outline,
                  size: 50,
                  color: Color(0xFF4A2C2A),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Sécurisez votre compte",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2C2A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Créez un mot de passe sécurisé",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        _buildPasswordField(
          controller: _passwordController,
          focusNode: _passwordFocus,
          label: "Mot de passe",
          isVisible: _isPasswordVisible,
          onVisibilityToggle: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => _confirmPasswordFocus.requestFocus(),
        ),
        const SizedBox(height: 16),
        _buildPasswordField(
          controller: _confirmPasswordController,
          focusNode: _confirmPasswordFocus,
          label: "Confirmer le mot de passe",
          isVisible: _isConfirmPasswordVisible,
          onVisibilityToggle: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _nextStep(),
        ),
      ],
    );
  }

  // Étape 4: Conditions et validation
  Widget _buildStep4() {
    return Column(
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.shade100,
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.assignment_turned_in_outlined,
                  size: 50,
                  color: Color(0xFF4A2C2A),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Validation",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2C2A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Acceptez les conditions pour continuer",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),

        // Récapitulatif
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8DADA),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              const Text(
                "Récapitulatif",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2C2A),
                ),
              ),
              const SizedBox(height: 12),
              _infoRow("Prénom", _firstNameController.text.trim()),
              _infoRow("Nom", _lastNameController.text.trim()),
              _infoRow("Email", _emailController.text.trim()),
              _infoRow("Téléphone", _phoneController.text.trim()),
              _infoRow("Adresse", _addressController.text.trim()),
            ],
          ),
        ),

        const SizedBox(height: 30),

        // Conditions d'utilisation et Politique de confidentialité
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8DADA).withOpacity(0.5),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFF4A2C2A).withOpacity(0.3)),
          ),
          child: Column(
            children: [
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
                  const SizedBox(width: 8),
                  const Text(
                    "J'accepte les ",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  GestureDetector(
                    onTap: () => _showTermsDialog(context),
                    child: const Text(
                      "conditions d'utilisation",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4A2C2A),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const SizedBox(width: 40),
                  GestureDetector(
                    onTap: () => _showPrivacyDialog(context),
                    child: const Text(
                      "Politique de confidentialité",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4A2C2A),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A2C2A),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? "Non renseigné" : value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    Function(String)? onSubmitted,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
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
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
    TextInputAction textInputAction = TextInputAction.next,
    Function(String)? onSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: !isVisible,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
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
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
    );
  }
}