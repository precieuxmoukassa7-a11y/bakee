import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/product_model.dart';
import 'home_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> _cartItems = [];
  bool _isLoading = true;

  // Liste complète des produits (à remplacer par ton API)
  final List<ProductModel> _allProducts = [
    ProductModel(
      id: '1',
      name: "Cupcake Chocolat",
      price: 2500,
      currency: "FCFA",
      image: "assets/cupcake1.png",
      rating: 4.8,
      category: "Gâteaux",
      isFavorite: false, description: '',
    ),
    ProductModel(
      id: '2',
      name: "Cupcake Vanille",
      price: 2000,
      currency: "FCFA",
      image: "assets/cupcake2.png",
      rating: 4.6,
      category: "Gâteaux",
      isFavorite: false, description: '',
    ),
    ProductModel(
      id: '3',
      name: "Donut Glacé",
      price: 1500,
      currency: "FCFA",
      image: "assets/donut.png",
      rating: 4.7,
      category: "Snacks",
      isFavorite: false, description: '',
    ),
    ProductModel(
      id: '4',
      name: "Tarte aux Fraises",
      price: 3500,
      currency: "FCFA",
      image: "assets/tarte.png",
      rating: 4.9,
      category: "Tartes",
      isFavorite: false, description: '',
    ),
    ProductModel(
      id: '5',
      name: "Macaron Assortis",
      price: 4500,
      currency: "FCFA",
      image: "assets/macaron.png",
      rating: 5.0,
      category: "Gâteaux",
      isFavorite: false, description: '',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    String? cartJson = prefs.getString('cart');

    if (cartJson != null && cartJson.isNotEmpty) {
      List<dynamic> decoded = jsonDecode(cartJson);
      _cartItems = decoded.map((item) => CartItem.fromJson(item)).toList();
    } else {
      _cartItems = [];
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> cartData = _cartItems.map((item) => item.toJson()).toList();
    await prefs.setString('cart', jsonEncode(cartData));
  }

  void _addQuantity(CartItem item) {
    setState(() {
      item.quantity++;
    });
    _saveCart();
  }

  void _removeQuantity(CartItem item) {
    setState(() {
      if (item.quantity > 1) {
        item.quantity--;
      } else {
        _cartItems.remove(item);
      }
    });
    _saveCart();
  }

  void _removeItem(CartItem item) {
    setState(() {
      _cartItems.remove(item);
    });
    _saveCart();
    _showSnackBar("${item.productName} retiré du panier", Colors.red);
  }

  void _clearCart() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Vider le panier"),
        content: const Text("Êtes-vous sûr de vouloir vider votre panier ?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _cartItems.clear();
              });
              _saveCart();
              Navigator.pop(context);
              _showSnackBar("Panier vidé", Colors.orange);
            },
            child: const Text("Vider", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  double get _totalPrice {
    double total = 0;
    for (var item in _cartItems) {
      total += item.price * item.quantity;
    }
    return total;
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

  void _checkout() {
    if (_cartItems.isEmpty) {
      _showSnackBar("Votre panier est vide", Colors.orange);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Validation de commande"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Récapitulatif de votre commande :"),
            const SizedBox(height: 10),
            ..._cartItems.map((item) => Text(
              "• ${item.productName} x${item.quantity} : ${(item.price * item.quantity).toStringAsFixed(0)} ${item.currency}",
              style: const TextStyle(fontSize: 12),
            )),
            const Divider(),
            Text(
              "Total : ${_totalPrice.toStringAsFixed(0)} FCFA",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar("Commande validée ! 🎉", Colors.green);
              _clearCart();
            },
            child: const Text("Confirmer", style: TextStyle(color: Colors.green)),
          ),
        ],
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
          "Mon panier",
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
          if (_cartItems.isNotEmpty)
            IconButton(
              onPressed: _clearCart,
              icon: const Icon(Icons.delete_outline, color: Color(0xFF4A2C2A)),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Color(0xFF4A2C2A)),
      )
          : _cartItems.isEmpty
          ? _buildEmptyCart()
          : _buildCartList(),
      bottomNavigationBar: _cartItems.isNotEmpty
          ? Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total :",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A2C2A),
                    ),
                  ),
                  Text(
                    "${_totalPrice.toStringAsFixed(0)} FCFA",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A2C2A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _checkout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A2C2A),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "Valider la commande",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
          : null,
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          Text(
            "Votre panier est vide",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Ajoutez des pâtisseries pour commencer",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A2C2A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              "Découvrir",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _cartItems.length,
      itemBuilder: (context, index) {
        final item = _cartItems[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
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
              // Image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                child: Image.asset(
                  item.imageUrl,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 100,
                      width: 100,
                      color: const Color(0xFFFDECEC),
                      child: const Icon(
                        Icons.cake,
                        size: 40,
                        color: Color(0xFF4A2C2A),
                      ),
                    );
                  },
                ),
              ),
              // Infos
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF4A2C2A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${item.price.toStringAsFixed(0)} ${item.currency}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Quantité
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _removeQuantity(item),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFDECEC),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.remove,
                                size: 18,
                                color: Color(0xFF4A2C2A),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              "${item.quantity}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4A2C2A),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _addQuantity(item),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4A2C2A),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Prix total
                          Text(
                            "${(item.price * item.quantity).toStringAsFixed(0)} ${item.currency}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF4A2C2A),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Bouton supprimer
                          IconButton(
                            onPressed: () => _removeItem(item),
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ================= MODÈLE PANIER =================
class CartItem {
  String productId;
  String productName;
  double price;
  String currency;
  String imageUrl;
  int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.currency,
    required this.imageUrl,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'currency': currency,
      'imageUrl': imageUrl,
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'],
      productName: json['productName'],
      price: json['price'],
      currency: json['currency'],
      imageUrl: json['imageUrl'],
      quantity: json['quantity'],
    );
  }
}