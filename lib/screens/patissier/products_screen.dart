import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'add_product_screen.dart';
import 'edit_product_screen.dart';

class PatissierProductsScreen extends StatefulWidget {
  const PatissierProductsScreen({super.key});

  @override
  State<PatissierProductsScreen> createState() => _PatissierProductsScreenState();
}

class _PatissierProductsScreenState extends State<PatissierProductsScreen> {
  List<Product> _products = [];
  bool _isLoading = true;
  String _selectedFilter = 'Tous';

  final List<String> _filterOptions = ['Tous', 'Disponibles', 'Indisponibles'];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    // Simuler le chargement
    await Future.delayed(const Duration(milliseconds: 500));

    final prefs = await SharedPreferences.getInstance();
    List<String>? savedProducts = prefs.getStringList('patissier_products');

    if (savedProducts != null && savedProducts.isNotEmpty) {
      List<Product> products = [];
      for (String productJson in savedProducts) {
        final Map<String, dynamic> data = json.decode(productJson);
        products.add(Product(
          id: data['id'],
          name: data['name'],
          description: data['description'],
          price: data['price'],
          category: data['category'],
          imageUrl: data['imageUrl'],
          isAvailable: data['isAvailable'],
          stock: data['stock'] ?? 0,
        ));
      }
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } else {
      // Produits par défaut
      setState(() {
        _products = [
          Product(
            id: '1',
            name: 'Croissant',
            description: 'Croissant feuilleté au beurre',
            price: 1.50,
            category: 'Viennoiseries',
            imageUrl: '🥐',
            isAvailable: true,
            stock: 50,
          ),
          Product(
            id: '2',
            name: 'Pain au chocolat',
            description: 'Pain au chocolat pur beurre',
            price: 1.50,
            category: 'Viennoiseries',
            imageUrl: '🍫',
            isAvailable: true,
            stock: 45,
          ),
          Product(
            id: '3',
            name: 'Tarte aux fraises',
            description: 'Tarte fraîche aux fraises et crème pâtissière',
            price: 4.50,
            category: 'Tartes',
            imageUrl: '🍓',
            isAvailable: true,
            stock: 12,
          ),
          Product(
            id: '4',
            name: 'Éclair au chocolat',
            description: 'Éclair garni de crème pâtissière au chocolat',
            price: 3.20,
            category: 'Pâtisseries',
            imageUrl: '🍫',
            isAvailable: false,
            stock: 0,
          ),
          Product(
            id: '5',
            name: 'Macaron',
            description: 'Macaron parfumé à la vanille',
            price: 1.80,
            category: 'Pâtisseries',
            imageUrl: '🍪',
            isAvailable: true,
            stock: 30,
          ),
        ];
        _isLoading = false;
      });
      // Sauvegarder les produits par défaut
      await _saveProductsToPrefs();
    }
  }

  Future<void> _saveProductsToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> productsJson = _products.map((p) => json.encode(p.toJson())).toList();
    await prefs.setStringList('patissier_products', productsJson);
  }

  List<Product> get _filteredProducts {
    if (_selectedFilter == 'Disponibles') {
      return _products.where((p) => p.isAvailable).toList();
    } else if (_selectedFilter == 'Indisponibles') {
      return _products.where((p) => !p.isAvailable).toList();
    }
    return _products;
  }

  Future<void> _addProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddProductScreen()),
    );

    if (result == true) {
      await _loadProducts();
      _showSnackBar("Produit ajouté avec succès !", Colors.green);
    }
  }

  Future<void> _editProduct(Product product) async {
    // TODO: Implémenter l'écran de modification
    _showSnackBar("Modification - Bientôt disponible", const Color(0xFF4A2C2A));
  }

  Future<void> _deleteProduct(Product product) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_amber_rounded, size: 60, color: Colors.orange),
                const SizedBox(height: 16),
                const Text(
                  "Supprimer le produit",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Voulez-vous vraiment supprimer \"${product.name}\" ?",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Annuler"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _products.removeWhere((p) => p.id == product.id);
                          });
                          await _saveProductsToPrefs();
                          Navigator.pop(context);
                          _showSnackBar("Produit supprimé", Colors.red);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Supprimer"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _toggleAvailability(Product product) async {
    setState(() {
      product.isAvailable = !product.isAvailable;
    });
    await _saveProductsToPrefs();
    _showSnackBar(
      product.isAvailable
          ? "${product.name} est maintenant disponible"
          : "${product.name} n'est plus disponible",
      const Color(0xFF4A2C2A),
    );
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
          "Mes Produits",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _addProduct,
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Color(0xFF4A2C2A)),
      )
          : _products.isEmpty
          ? _buildEmptyState()
          : Column(
        children: [
          // Filtres
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Text(
                  "Filtrer :",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4A2C2A),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filterOptions.map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(filter),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                            backgroundColor: Colors.grey.shade100,
                            selectedColor: const Color(0xFF4A2C2A).withOpacity(0.1),
                            checkmarkColor: const Color(0xFF4A2C2A),
                            labelStyle: TextStyle(
                              color: isSelected ? const Color(0xFF4A2C2A) : Colors.black87,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Liste des produits
          Expanded(
            child: _filteredProducts.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8DADA),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.filter_alt_off,
                      size: 50,
                      color: const Color(0xFF4A2C2A).withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Aucun produit correspondant",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return _buildProductCard(product);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
        backgroundColor: const Color(0xFF4A2C2A),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8DADA),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.fastfood_outlined,
              size: 60,
              color: Color(0xFF4A2C2A),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Aucun produit",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A2C2A),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Ajoutez votre premier produit",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _addProduct,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A2C2A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Ajouter un produit"),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _editProduct(product),
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Image/Icone
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8DADA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      product.imageUrl,
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Infos produit
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4A2C2A),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: product.isAvailable
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              product.isAvailable ? "Disponible" : "Indisponible",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: product.isAvailable ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8DADA),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              product.category,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF4A2C2A),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${product.price.toStringAsFixed(2)} €",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A2C2A),
                            ),
                          ),
                          if (product.stock > 0) ...[
                            const SizedBox(width: 8),
                            Text(
                              "Stock: ${product.stock}",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // Actions
                Column(
                  children: [
                    IconButton(
                      onPressed: () => _toggleAvailability(product),
                      icon: Icon(
                        product.isAvailable ? Icons.visibility : Icons.visibility_off,
                        color: const Color(0xFF4A2C2A),
                        size: 20,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _deleteProduct(product),
                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Modèle Product
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