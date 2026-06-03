import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/product_model.dart';
import '../models/product_model.dart';
import 'cart_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Tous';
  int _cartCount = 0;

  final List<String> _categories = [
    'Tous', 'Gâteaux', 'Tartes', 'Pains', 'Snacks', 'Glaces', 'Boissons'
  ];

  final List<ProductModel> _allProducts = [
    ProductModel(
      id: '1',
      name: "Cupcake Chocolat",
      price: 2500,
      currency: "FCFA",
      image: "assets/cupcake1.png",
      rating: 4.8,
      category: "Gâteaux",
      description: "Délicieux cupcake au chocolat fondant avec un glaçage onctueux.",
      isFavorite: false,
    ),
    ProductModel(
      id: '2',
      name: "Cupcake Vanille",
      price: 2000,
      currency: "FCFA",
      image: "assets/cupcake2.png",
      rating: 4.6,
      category: "Gâteaux",
      description: "Cupcake à la vanille de Madagascar, léger et aérien.",
      isFavorite: true,
    ),
    ProductModel(
      id: '3',
      name: "Donut Glacé",
      price: 1500,
      currency: "FCFA",
      image: "assets/donut.png",
      rating: 4.7,
      category: "Snacks",
      description: "Donut recouvert d'un glaçage sucré et coloré.",
      isFavorite: false,
    ),
    ProductModel(
      id: '4',
      name: "Tarte aux Fraises",
      price: 3500,
      currency: "FCFA",
      image: "assets/tarte.png",
      rating: 4.9,
      category: "Tartes",
      description: "Tarte fraîche aux fraises avec une crème pâtissière légère.",
      isFavorite: false,
    ),
    ProductModel(
      id: '5',
      name: "Macaron Assortis",
      price: 4500,
      currency: "FCFA",
      image: "assets/macaron.png",
      rating: 5.0,
      category: "Gâteaux",
      description: "Assortiment de macarons aux saveurs variées.",
      isFavorite: false,
    ),
    ProductModel(
      id: '6',
      name: "Pain au Chocolat",
      price: 1200,
      currency: "FCFA",
      image: "assets/pain_chocolat.png",
      rating: 4.5,
      category: "Pains",
      description: "Pain au chocolat feuilleté avec deux barres de chocolat.",
      isFavorite: false,
    ),
    ProductModel(
      id: '7',
      name: "Croissant",
      price: 1000,
      currency: "FCFA",
      image: "assets/croissant.png",
      rating: 4.6,
      category: "Pains",
      description: "Croissant croustillant et beurré, fait maison.",
      isFavorite: false,
    ),
    ProductModel(
      id: '8',
      name: "Glace Vanille",
      price: 1800,
      currency: "FCFA",
      image: "assets/glace.png",
      rating: 4.7,
      category: "Glaces",
      description: "Glace à la vanille naturelle, onctueuse et rafraîchissante.",
      isFavorite: false,
    ),
    ProductModel(
      id: '9',
      name: "Jus d'Orange",
      price: 800,
      currency: "FCFA",
      image: "assets/jus.png",
      rating: 4.4,
      category: "Boissons",
      description: "Jus d'orange frais pressé, sans sucre ajouté.",
      isFavorite: false,
    ),
    ProductModel(
      id: '10',
      name: "Éclair au Chocolat",
      price: 2200,
      currency: "FCFA",
      image: "assets/eclair.png",
      rating: 4.8,
      category: "Gâteaux",
      description: "Éclair garni de crème pâtissière au chocolat.",
      isFavorite: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadCartCount();
  }

  Future<void> _loadCartCount() async {
    final prefs = await SharedPreferences.getInstance();
    String? cartJson = prefs.getString('cart');

    if (cartJson != null && cartJson.isNotEmpty) {
      List<dynamic> decoded = jsonDecode(cartJson);
      int count = 0;
      for (var item in decoded) {
        count += (item['quantity'] ?? 0) as int;
      }
      setState(() {
        _cartCount = count;
      });
    } else {
      setState(() {
        _cartCount = 0;
      });
    }
  }

  List<ProductModel> get _filteredProducts {
    List<ProductModel> filtered = _allProducts;

    if (_selectedCategory != 'Tous') {
      filtered = filtered.where((product) => product.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((product) => product.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _addToCart(ProductModel product) {
    _showSnackBar("${product.name} ajouté au panier 🛒", Colors.green);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Nos Produits",
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
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoriesFilter(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${_filteredProducts.length} produit(s) trouvé(s)",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ),
          ),
          Expanded(
            child: _filteredProducts.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    "Aucun produit trouvé",
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Essayez une autre recherche",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return _buildProductCard(product);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: "Rechercher un produit...",
            hintStyle: TextStyle(color: Colors.grey.shade500),
            prefixIcon: const Icon(Icons.search, color: Color(0xFF4A2C2A)),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _searchController.clear();
                });
              },
            )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesFilter() {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF4A2C2A) : const Color(0xFFF8DADA),
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? null
                    : Border.all(color: const Color(0xFF4A2C2A).withOpacity(0.3)),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF4A2C2A),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return GestureDetector(
      onTap: () {
        _showSnackBar("Détail de ${product.name} - Bientôt disponible", const Color(0xFF4A2C2A));
      },
      child: Container(
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
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      product.image,
                      height: 120,
                      width: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
                          width: 140,
                          color: const Color(0xFFF8DADA),
                          child: const Icon(
                            Icons.cake,
                            size: 50,
                            color: Color(0xFF4A2C2A),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF4A2C2A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 12,
                        color: Colors.amber.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.rating.toString(),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    product.formattedPrice,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF4A2C2A),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    product.isFavorite = !product.isFavorite;
                  });
                  _showSnackBar(
                    product.isFavorite
                        ? "Ajouté aux favoris ❤️"
                        : "Retiré des favoris 💔",
                    product.isFavorite ? Colors.green : Colors.red,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 16,
                    color: product.isFavorite ? Colors.red : Colors.grey,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => _addToCart(product),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A2C2A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.add_shopping_cart,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}