import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'cart_screen.dart';

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
                  ? "Vos commandes apparaîtront ici"
                  : "Vos commandes passées apparaîtront ici",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
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

// Widget Carte Commande avec timeline
class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
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

  // Déterminer l'étape actuelle pour la timeline
  int _getCurrentStep(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.confirmed:
        return 1;
      case OrderStatus.preparing:
        return 2;
      case OrderStatus.ready:
        return 3;
      case OrderStatus.delivered:
        return 4;
      case OrderStatus.cancelled:
        return -1; // Annulé
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = _getCurrentStep(order.status);
    final isCancelled = order.status == OrderStatus.cancelled;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête de la commande
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getStatusColor(order.status).withOpacity(0.1),
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
                      color: _getStatusColor(order.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusText(order.status),
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

            // Timeline de localisation
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isCancelled) ...[
                    const Text(
                      "Suivi de votre commande",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A2C2A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTimelineStep(
                            icon: Icons.receipt_outlined,
                            label: "En attente",
                            isCompleted: currentStep >= 0,
                            isActive: currentStep == 0,
                            isLast: false,
                          ),
                        ),
                        Expanded(
                          child: _buildTimelineStep(
                            icon: Icons.check_circle_outline,
                            label: "Confirmée",
                            isCompleted: currentStep >= 1,
                            isActive: currentStep == 1,
                            isLast: false,
                          ),
                        ),
                        Expanded(
                          child: _buildTimelineStep(
                            icon: Icons.kitchen,
                            label: "Préparation",
                            isCompleted: currentStep >= 2,
                            isActive: currentStep == 2,
                            isLast: false,
                          ),
                        ),
                        Expanded(
                          child: _buildTimelineStep(
                            icon: Icons.shopping_bag,
                            label: "Prête",
                            isCompleted: currentStep >= 3,
                            isActive: currentStep == 3,
                            isLast: false,
                          ),
                        ),
                        Expanded(
                          child: _buildTimelineStep(
                            icon: Icons.delivery_dining,
                            label: "Livrée",
                            isCompleted: currentStep >= 4,
                            isActive: currentStep == 4,
                            isLast: true,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Timeline pour commande annulée
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.cancel, color: Colors.red, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Commande annulée",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.red,
                                  ),
                                ),
                                Text(
                                  "Annulée le ${order.formattedDate}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),

                  // Produits
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

  Widget _buildTimelineStep({
    required IconData icon,
    required String label,
    required bool isCompleted,
    required bool isActive,
    required bool isLast,
  }) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            if (!isLast)
              Container(
                height: 2,
                color: isCompleted ? const Color(0xFF4A2C2A) : Colors.grey.shade300,
                margin: const EdgeInsets.only(left: 20, right: 0),
              ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isCompleted ? const Color(0xFF4A2C2A) : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isCompleted ? const Color(0xFF4A2C2A) : Colors.grey.shade500,
          ),
          textAlign: TextAlign.center,
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 4,
            width: 20,
            decoration: BoxDecoration(
              color: const Color(0xFF4A2C2A),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
      ],
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

  String get formattedTotal => "${total.toStringAsFixed(0)} FCFA";

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

  double get subtotal => (price * quantity).toDouble();
}

// Écran de détail d'une commande (simplifié)
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

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
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

  String _getStatusText(OrderStatus status) {
    switch (status) {
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
                          _getStatusText(_order.status),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF4A2C2A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(_getStatusIcon(_order.status), size: 32, color: _getStatusColor(_order.status)),
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