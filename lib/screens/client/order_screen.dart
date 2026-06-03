import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'cart_screen.dart';

// ⚠️ Supprimez l'import de intl si vous ne l'avez pas ajouté dans pubspec.yaml
// Si vous avez ajouté intl dans pubspec.yaml, gardez cet import :
// import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _selectedIndex = 0;
  int _cartCount = 0;

  List<Order> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCartCount();
    _loadOrders();
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
              // ✅ Correction : vérifier que quantity existe
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

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      String? ordersJson = prefs.getString('orders');

      if (ordersJson != null && ordersJson.isNotEmpty && ordersJson != 'null' && ordersJson != '[]') {
        final List<dynamic> decoded = jsonDecode(ordersJson);
        setState(() {
          _orders = decoded.map((json) => Order.fromJson(json)).toList();
          _orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
          _isLoading = false;
        });
      } else {
        setState(() {
          _orders = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _orders = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = jsonEncode(_orders.map((order) => order.toJson()).toList());
    await prefs.setString('orders', ordersJson);
  }

  void _createOrderFromCart() async {
    final prefs = await SharedPreferences.getInstance();
    String? cartJson = prefs.getString('cart');

    if (cartJson == null || cartJson.isEmpty || cartJson == 'null' || cartJson == '[]') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Votre panier est vide"),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final List<dynamic> cartItems = jsonDecode(cartJson);

    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Votre panier est vide"),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutScreen(
          cartItems: cartItems,
          onOrderPlaced: () {
            _loadOrders();
            _loadCartCount();
          },
        ),
      ),
    );
  }

  String _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return '#FF9800';
      case OrderStatus.confirmed:
        return '#2196F3';
      case OrderStatus.preparing:
        return '#9C27B0';
      case OrderStatus.ready:
        return '#4CAF50';
      case OrderStatus.delivered:
        return '#8BC34A';
      case OrderStatus.cancelled:
        return '#F44336';
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return "En attente";
      case OrderStatus.confirmed:
        return "Confirmée";
      case OrderStatus.preparing:
        return "En préparation";
      case OrderStatus.ready:
        return "Prête";
      case OrderStatus.delivered:
        return "Livrée";
      case OrderStatus.cancelled:
        return "Annulée";
    }
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.pending_actions;
      case OrderStatus.confirmed:
        return Icons.check_circle_outline;
      case OrderStatus.preparing:
        return Icons.kitchen;
      case OrderStatus.ready:
        return Icons.shopping_bag;
      case OrderStatus.delivered:
        return Icons.delivery_dining;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Mes Commandes",
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: _buildTabBar(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createOrderFromCart,
        backgroundColor: const Color(0xFF4A2C2A),
        icon: const Icon(Icons.shopping_cart, color: Colors.white),
        label: const Text(
          "Nouvelle commande",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _buildTab(0, "En cours"),
          _buildTab(1, "Historique"),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String title) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4A2C2A) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    final activeOrders = _orders.where((order) =>
    order.status != OrderStatus.delivered &&
        order.status != OrderStatus.cancelled
    ).toList();

    final completedOrders = _orders.where((order) =>
    order.status == OrderStatus.delivered ||
        order.status == OrderStatus.cancelled
    ).toList();

    final ordersToShow = _selectedIndex == 0 ? activeOrders : completedOrders;

    if (ordersToShow.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _selectedIndex == 0 ? Icons.receipt_outlined : Icons.history,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              _selectedIndex == 0
                  ? "Aucune commande en cours"
                  : "Aucune commande dans l'historique",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _selectedIndex == 0
                  ? "Passez votre première commande"
                  : "Vos commandes passées apparaîtront ici",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
            if (_selectedIndex == 0)
              const SizedBox(height: 20),
            if (_selectedIndex == 0)
              ElevatedButton.icon(
                onPressed: _createOrderFromCart,
                icon: const Icon(Icons.shopping_cart),
                label: const Text("Commander maintenant"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A2C2A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ordersToShow.length,
      itemBuilder: (context, index) {
        final order = ordersToShow[index];
        return OrderCard(
          order: order,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OrderDetailScreen(
                  order: order,
                  onOrderUpdated: _loadOrders,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// Modèle de commande
enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  delivered,
  cancelled,
}

class Order {
  final String id;
  final DateTime orderDate;
  OrderStatus status;
  final List<CartItem> items;
  final double total;
  final String deliveryAddress;
  final String phoneNumber;
  final String? notes;

  Order({
    required this.id,
    required this.orderDate,
    required this.status,
    required this.items,
    required this.total,
    required this.deliveryAddress,
    required this.phoneNumber,
    this.notes,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderDate: DateTime.parse(json['orderDate']),
      status: OrderStatus.values.firstWhere(
            (e) => e.toString() == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      total: json['total'],
      deliveryAddress: json['deliveryAddress'],
      phoneNumber: json['phoneNumber'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderDate': orderDate.toIso8601String(),
      'status': status.toString(),
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
      'deliveryAddress': deliveryAddress,
      'phoneNumber': phoneNumber,
      'notes': notes,
    };
  }

  // ✅ Correction : méthode sans intl
  String get formattedTotal => "${total.toStringAsFixed(0)} FCFA";

  // ✅ Correction : formatage de date sans intl
  String get formattedDate {
    final year = orderDate.year;
    final month = orderDate.month.toString().padLeft(2, '0');
    final day = orderDate.day.toString().padLeft(2, '0');
    final hour = orderDate.hour.toString().padLeft(2, '0');
    final minute = orderDate.minute.toString().padLeft(2, '0');
    return "$day/$month/$year $hour:$minute";
  }
}

class CartItem {
  final String id;
  final String name;
  final int price;
  final String currency;
  final String image;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.image,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      currency: json['currency'],
      image: json['image'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'currency': currency,
      'image': image,
      'quantity': quantity,
    };
  }

  String get formattedPrice => "$price $currency";

  // ✅ Correction : price * quantity
  double get subtotal => (price * quantity).toDouble();
}

// Widget Carte Commande
class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  Color _getStatusColor() {
    switch (order.status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.purple;
      case OrderStatus.ready:
        return Colors.green;
      case OrderStatus.delivered:
        return Colors.lightGreen;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText() {
    switch (order.status) {
      case OrderStatus.pending:
        return "En attente";
      case OrderStatus.confirmed:
        return "Confirmée";
      case OrderStatus.preparing:
        return "En préparation";
      case OrderStatus.ready:
        return "Prête";
      case OrderStatus.delivered:
        return "Livrée";
      case OrderStatus.cancelled:
        return "Annulée";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getStatusColor().withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Commande #${order.id.substring(0, order.id.length > 8 ? 8 : order.id.length)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.formattedDate,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusText(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  ...order.items.take(2).map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            item.image,
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 40,
                                width: 40,
                                color: const Color(0xFFF8DADA),
                                child: const Icon(Icons.fastfood, size: 20),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "x${item.quantity}",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "${(item.price * item.quantity).toStringAsFixed(0)} FCFA",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )),
                  if (order.items.length > 2)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "+${order.items.length - 2} autre(s) produit(s)",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        order.formattedTotal,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF4A2C2A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Écran de validation de commande
class CheckoutScreen extends StatefulWidget {
  final List<dynamic> cartItems;
  final VoidCallback onOrderPlaced;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.onOrderPlaced,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isProcessing = false;

  double get _total {
    double sum = 0;
    for (var item in widget.cartItems) {
      sum += (item['price'] as int) * (item['quantity'] as int);
    }
    return sum;
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    final prefs = await SharedPreferences.getInstance();

    String? ordersJson = prefs.getString('orders');
    List<Order> orders = [];

    if (ordersJson != null && ordersJson.isNotEmpty && ordersJson != 'null') {
      final List<dynamic> decoded = jsonDecode(ordersJson);
      orders = decoded.map((json) => Order.fromJson(json)).toList();
    }

    final newOrder = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      orderDate: DateTime.now(),
      status: OrderStatus.pending,
      items: widget.cartItems.map((item) => CartItem(
        id: item['id'],
        name: item['name'],
        price: item['price'],
        currency: item['currency'],
        image: item['image'],
        quantity: item['quantity'],
      )).toList(),
      total: _total,
      deliveryAddress: _addressController.text,
      phoneNumber: _phoneController.text,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );

    orders.insert(0, newOrder);

    final newOrdersJson = jsonEncode(orders.map((order) => order.toJson()).toList());
    await prefs.setString('orders', newOrdersJson);

    await prefs.remove('cart');

    widget.onOrderPlaced();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Commande passée avec succès ! 🎉"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Validation de la commande"),
        backgroundColor: const Color(0xFF4A2C2A),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8DADA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Résumé de la commande",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF4A2C2A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...widget.cartItems.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${item['name']} x${item['quantity']}",
                                  style: const TextStyle(fontSize: 13),
                                ),
                                Text(
                                  "${(item['price'] as int) * (item['quantity'] as int)} FCFA",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          )),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "${_total.toStringAsFixed(0)} FCFA",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF4A2C2A),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Informations de livraison",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: "Adresse de livraison",
                        hintText: "Ex: Quartier, Rue, Ville",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer votre adresse";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: "Numéro de téléphone",
                        hintText: "Ex: 6 XX XX XX XX",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer votre numéro";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: "Instructions spéciales (optionnel)",
                        hintText: "Ex: Sonnez à la porte, laissez devant...",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.note_add),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Mode de paiement",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.payments, color: Color(0xFF4A2C2A)),
                          SizedBox(width: 12),
                          Text("Paiement à la livraison"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A2C2A),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isProcessing
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text(
                  "CONFIRMER LA COMMANDE",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Écran de détail d'une commande
class OrderDetailScreen extends StatefulWidget {
  final Order order;
  final VoidCallback onOrderUpdated;

  const OrderDetailScreen({
    super.key,
    required this.order,
    required this.onOrderUpdated,
  });

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late Order _order;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  Future<void> _cancelOrder() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Annuler la commande"),
        content: const Text("Êtes-vous sûr de vouloir annuler cette commande ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Non"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              setState(() {
                _order.status = OrderStatus.cancelled;
              });

              final prefs = await SharedPreferences.getInstance();
              String? ordersJson = prefs.getString('orders');

              if (ordersJson != null && ordersJson.isNotEmpty) {
                List<dynamic> decoded = jsonDecode(ordersJson);
                for (var i = 0; i < decoded.length; i++) {
                  if (decoded[i]['id'] == _order.id) {
                    decoded[i]['status'] = OrderStatus.cancelled.toString();
                    break;
                  }
                }
                await prefs.setString('orders', jsonEncode(decoded));
              }

              widget.onOrderUpdated();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Commande annulée"),
                  backgroundColor: Colors.orange,
                ),
              );

              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text("Oui", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (_order.status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.purple;
      case OrderStatus.ready:
        return Colors.green;
      case OrderStatus.delivered:
        return Colors.lightGreen;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText() {
    switch (_order.status) {
      case OrderStatus.pending:
        return "En attente de confirmation";
      case OrderStatus.confirmed:
        return "Confirmée";
      case OrderStatus.preparing:
        return "En préparation";
      case OrderStatus.ready:
        return "Prête à être livrée";
      case OrderStatus.delivered:
        return "Livrée";
      case OrderStatus.cancelled:
        return "Annulée";
    }
  }

  IconData _getStatusIcon() {
    switch (_order.status) {
      case OrderStatus.pending:
        return Icons.pending_actions;
      case OrderStatus.confirmed:
        return Icons.check_circle_outline;
      case OrderStatus.preparing:
        return Icons.kitchen;
      case OrderStatus.ready:
        return Icons.shopping_bag;
      case OrderStatus.delivered:
        return Icons.delivery_dining;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Commande #${_order.id.substring(0, _order.id.length > 8 ? 8 : _order.id.length)}"),
        backgroundColor: const Color(0xFF4A2C2A),
        foregroundColor: Colors.white,
        actions: [
          if (_order.status == OrderStatus.pending)
            IconButton(
              onPressed: _cancelOrder,
              icon: const Icon(Icons.cancel_outlined),
              tooltip: "Annuler la commande",
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF4A2C2A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFF4A2C2A)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Statut de la commande",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          _getStatusText(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF4A2C2A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(_getStatusIcon(), size: 32, color: _getStatusColor()),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text("Date de commande"),
                subtitle: Text(_order.formattedDate),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text("Adresse de livraison"),
                subtitle: Text(_order.deliveryAddress),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone),
                title: const Text("Téléphone"),
                subtitle: Text(_order.phoneNumber),
              ),
            ),
            if (_order.notes != null)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.note),
                  title: const Text("Instructions"),
                  subtitle: Text(_order.notes!),
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              "Produits commandés",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            ..._order.items.map((item) => Card(
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    item.image,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 50,
                        width: 50,
                        color: const Color(0xFFF8DADA),
                        child: const Icon(Icons.fastfood),
                      );
                    },
                  ),
                ),
                title: Text(item.name),
                subtitle: Text("Quantité: ${item.quantity}"),
                trailing: Text(
                  "${(item.price * item.quantity).toStringAsFixed(0)} FCFA",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )),
            const Divider(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  _order.formattedTotal,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF4A2C2A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}