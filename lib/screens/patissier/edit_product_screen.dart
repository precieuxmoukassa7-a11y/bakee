import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'products_screen.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;
  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;

  // Variables
  late String _selectedCategory;
  late String _selectedEmoji;
  late bool _isAvailable;
  bool _isLoading = false;

  // Focus nodes
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _priceFocus = FocusNode();
  final FocusNode _stockFocus = FocusNode();

  // Options
  final List<String> _categories = [
    'Viennoiseries',
    'Pâtisseries',
    'Tartes',
    'Gâteaux',
    'Cookies',
    'Sandwichs',
    'Boissons',
    'Autres'
  ];

  final List<String> _availableEmojis = [
    '🥐', '🍫', '🥖', '🍰', '🎂', '🥧', '🍪', '🍩', '🧁', '🍮',
    '🍓', '🍎', '🍊', '🍋', '🍦', '☕', '🥤', '🧃', '🍵'
  ];

  @override
  void initState() {
    super.initState();
    // Initialiser les contrôleurs avec les données du produit
    _nameController = TextEditingController(text: widget.product.name);
    _descriptionController = TextEditingController(text: widget.product.description);
    _priceController = TextEditingController(text: widget.product.price.toString());
    _stockController = TextEditingController(text: widget.product.stock.toString());
    _selectedCategory = widget.product.category;
    _selectedEmoji = widget.product.imageUrl;
    _isAvailable = widget.product.isAvailable;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _nameFocus.dispose();
    _descriptionFocus.dispose();
    _priceFocus.dispose();
    _stockFocus.dispose();
    super.dispose();
  }

  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simuler un appel API
      await Future.delayed(const Duration(seconds: 1));

      try {
        final prefs = await SharedPreferences.getInstance();

        // Récupérer la liste existante des produits
        List<String>? existingProducts = prefs.getStringList('patissier_products');
        List<Map<String, dynamic>> products = [];

        if (existingProducts != null) {
          for (String productJson in existingProducts) {
            products.add(json.decode(productJson));
          }
        }

        // Trouver et mettre à jour le produit
        final index = products.indexWhere((p) => p['id'] == widget.product.id);

        if (index != -1) {
          products[index] = {
            'id': widget.product.id,
            'name': _nameController.text.trim(),
            'description': _descriptionController.text.trim(),
            'price': double.parse(_priceController.text),
            'category': _selectedCategory,
            'imageUrl': _selectedEmoji,
            'isAvailable': _isAvailable,
            'stock': int.tryParse(_stockController.text) ?? 0,
            'updatedAt': DateTime.now().toIso8601String(),
          };
        }

        // Sauvegarder la liste mise à jour
        List<String> productsJson = products.map((p) => json.encode(p)).toList();
        await prefs.setStringList('patissier_products', productsJson);

        if (mounted) {
          _showSnackBar("Produit modifié avec succès ! ✏️", Colors.green);

          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              Navigator.pop(context, true);
            }
          });
        }
      } catch (e) {
        if (mounted) {
          _showSnackBar("Erreur lors de la modification", Colors.red);
          setState(() {
            _isLoading = false;
          });
        }
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A2C2A),
        elevation: 0,
        title: const Text(
          "Modifier le produit",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _updateProduct,
            child: const Text(
              "Enregistrer",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF4A2C2A)),
            SizedBox(height: 16),
            Text(
              "Modification en cours...",
              style: TextStyle(color: Color(0xFF4A2C2A)),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icône / Image
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8DADA),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.shade100,
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _selectedEmoji,
                          style: const TextStyle(fontSize: 60),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Choisir une icône",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4A2C2A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Sélecteur d'emoji
                    SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _availableEmojis.length,
                        itemBuilder: (context, index) {
                          final emoji = _availableEmojis[index];
                          final isSelected = _selectedEmoji == emoji;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedEmoji = emoji;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              width: 55,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF4A2C2A).withOpacity(0.1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF4A2C2A)
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  emoji,
                                  style: const TextStyle(fontSize: 35),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Nom du produit
              const Text(
                "Informations générales",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2C2A),
                ),
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _nameController,
                focusNode: _nameFocus,
                label: "Nom du produit",
                hint: "Ex: Croissant au beurre",
                icon: Icons.production_quantity_limits,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer le nom du produit";
                  }
                  if (value.length < 3) {
                    return "Nom trop court (minimum 3 caractères)";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Description
              _buildTextField(
                controller: _descriptionController,
                focusNode: _descriptionFocus,
                label: "Description",
                hint: "Décrivez votre produit...",
                icon: Icons.description,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer une description";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Prix et Stock
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _priceController,
                      focusNode: _priceFocus,
                      label: "Prix (€)",
                      hint: "0.00",
                      icon: Icons.euro,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Requis";
                        }
                        if (double.tryParse(value) == null) {
                          return "Prix invalide";
                        }
                        if (double.parse(value) <= 0) {
                          return "> 0";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _stockController,
                      focusNode: _stockFocus,
                      label: "Stock",
                      hint: "Quantité",
                      icon: Icons.inventory,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (int.tryParse(value) == null) {
                            return "Nombre invalide";
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Catégorie
              const Text(
                "Catégorie",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2C2A),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8DADA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF4A2C2A)),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(
                          category,
                          style: const TextStyle(color: Color(0xFF4A2C2A)),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Disponibilité
              const Text(
                "Disponibilité",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2C2A),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8DADA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SwitchListTile(
                  title: const Text(
                    "Produit disponible",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: const Text(
                    "Les clients pourront commander ce produit",
                    style: TextStyle(fontSize: 12),
                  ),
                  value: _isAvailable,
                  onChanged: (value) {
                    setState(() {
                      _isAvailable = value;
                    });
                  },
                  activeColor: const Color(0xFF4A2C2A),
                  contentPadding: EdgeInsets.zero,
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
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
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
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
}

// Modèle Product (à copier si pas déjà présent)
class Product {
  final String id;
  String name;
  String description;
  double price;
  String category;
  String imageUrl;
  bool isAvailable;
  int stock;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.isAvailable,
    this.stock = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'stock': stock,
    };
  }
}