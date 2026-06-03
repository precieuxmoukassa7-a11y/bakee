import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/product_model.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<ProductModel> _favorites = [];
  int _cartCount = 0;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _loadCartCount();
  }

  Future<void> _loadFavorites() async {
    // Charger les favoris depuis SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    String? favoritesJson = prefs.getString('favorites');

    if (favoritesJson != null && favoritesJson.isNotEmpty) {
      List<dynamic> decoded = jsonDecode(favoritesJson);
      setState(() {
        _favorites = decoded.map((json) => ProductModel.fromJson(json)).toList();
      });
    }
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

  void _removeFromFavorites(ProductModel product) async {
    setState(() {
      _favorites.removeWhere((item) => item.id == product.id);
    });

    // Sauvegarder les favoris
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = jsonEncode(_favorites.map((p) => p.toJson()).toList());
    await prefs.setString('favorites', favoritesJson);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Retiré des favoris 💔"),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _addToCart(ProductModel product) async {
    final prefs = await SharedPreferences.getInstance();
    String? cartJson = prefs.getString('cart');
    List<dynamic> cart = cartJson != null ? jsonDecode(cartJson) : [];

    int index = cart.indexWhere((item) => item['id'] == product.id);

    if (index != -1) {
      cart[index]['quantity'] = (cart[index]['quantity'] as int) + 1;
    } else {
      cart.add({
        'id': product.id,
        'name': product.name,
        'price': product.price,
        'currency': product.currency,
        'image': product.image,
        'quantity': 1,
      });
    }

    await prefs.setString('cart', jsonEncode(cart));
    _loadCartCount();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product.name} ajouté au panier 🛒"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
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
          "Mes Favoris",
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
      body: _favorites.isEmpty
          ? _buildEmptyState()
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final product = _favorites[index];
          return _buildFavoriteCard(product);
        },
      ),
    );
  }

  Widget _buildFavoriteCard(ProductModel product) {
    return Container(
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
                  maxLines: 2,
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
              onTap: () => _removeFromFavorites(product),
              child: Container(
                padding: const EdgeInsets.all(6),
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
                child: const Icon(
                  Icons.favorite,
                  size: 18,
                  color: Colors.red,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A2C2A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.add_shopping_cart,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            "Aucun favori",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Ajoutez vos produits préférés en cliquant sur le cœur ❤️",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}