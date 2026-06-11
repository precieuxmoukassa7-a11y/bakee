import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Ajoutez cette dépendance dans pubspec.yaml

class PatissierOrdersScreen extends StatefulWidget {
  const PatissierOrdersScreen({super.key});

  @override
  State<PatissierOrdersScreen> createState() => _PatissierOrdersScreenState();
}

class _PatissierOrdersScreenState extends State<PatissierOrdersScreen> {
  List<Order> _orders = [];
  bool _isLoading = true;
  String _selectedFilter = 'Toutes';
  String _selectedStatus = 'Tous';

  final List<String> _filterOptions = ['Toutes', 'Aujourd\'hui', 'Cette semaine', 'Ce mois'];
  final List<String> _statusOptions = ['Tous', 'En attente', 'Confirmée', 'En préparation', 'Prête', 'Livrée', 'Annulée'];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    // Simuler le chargement des commandes depuis une API
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _orders = _generateMockOrders();
      _isLoading = false;
    });
  }

  List<Order> _generateMockOrders() {
    return [
      Order(
        id: 'CMD-001',
        clientName: 'Sophie Martin',
        clientPhone: '06 12 34 56 78',
        clientAddress: '12 rue des Lilas, 75001 Paris',
        items: [
          OrderItem(name: 'Croissant', quantity: 2, price: 1.50),
          OrderItem(name: 'Pain au chocolat', quantity: 1, price: 1.50),
          OrderItem(name: 'Tarte aux fraises', quantity: 1, price: 4.50),
        ],
        total: 9.00,
        status: 'En attente',
        orderDate: DateTime.now(),
        deliveryTime: DateTime.now().add(const Duration(hours: 1)),
      ),
      Order(
        id: 'CMD-002',
        clientName: 'Jean Dupont',
        clientPhone: '06 98 76 54 32',
        clientAddress: '5 boulevard Haussmann, 75009 Paris',
        items: [
          OrderItem(name: 'Éclair au chocolat', quantity: 3, price: 3.20),
          OrderItem(name: 'Macaron', quantity: 6, price: 1.80),
        ],
        total: 20.40,
        status: 'Confirmée',
        orderDate: DateTime.now().subtract(const Duration(hours: 2)),
        deliveryTime: DateTime.now().add(const Duration(hours: 2)),
      ),
      Order(
        id: 'CMD-003',
        clientName: 'Marie Dubois',
        clientPhone: '06 45 67 89 01',
        clientAddress: '8 rue de la Paix, 75002 Paris',
        items: [
          OrderItem(name: 'Gâteau au chocolat', quantity: 1, price: 25.00),
          OrderItem(name: 'Fraisier', quantity: 1, price: 22.00),
        ],
        total: 47.00,
        status: 'En préparation',
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
        deliveryTime: DateTime.now().add(const Duration(hours: 3)),
      ),
      Order(
        id: 'CMD-004',
        clientName: 'Pierre Richard',
        clientPhone: '06 23 45 67 89',
        clientAddress: '15 avenue des Champs-Élysées, 75008 Paris',
        items: [
          OrderItem(name: 'Baguette tradition', quantity: 2, price: 1.20),
          OrderItem(name: 'Pain complet', quantity: 1, price: 2.00),
        ],
        total: 4.40,
        status: 'Livrée',
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
        deliveryTime: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Order(
        id: 'CMD-005',
        clientName: 'Isabelle Laurent',
        clientPhone: '06 67 89 01 23',
        clientAddress: '3 rue de Rivoli, 75004 Paris',
        items: [
          OrderItem(name: 'Mille-feuille', quantity: 2, price: 5.50),
          OrderItem(name: 'Opéra', quantity: 1, price: 6.00),
        ],
        total: 17.00,
        status: 'Prête',
        orderDate: DateTime.now().subtract(const Duration(hours: 5)),
        deliveryTime: DateTime.now().add(const Duration(hours: 1)),
      ),
      Order(
        id: 'CMD-006',
        clientName: 'Thomas Bernard',
        clientPhone: '06 78 90 12 34',
        clientAddress: '22 rue de la République, 75010 Paris',
        items: [
          OrderItem(name: 'Croissant', quantity: 4, price: 1.50),
          OrderItem(name: 'Pain au chocolat', quantity: 2, price: 1.50),
        ],
        total: 9.00,
        status: 'Annulée',
        orderDate: DateTime.now().subtract(const Duration(days: 3)),
        deliveryTime: null,
      ),
    ];
  }

  List<Order> get _filteredOrders {
    var filtered = _orders;

    // Filtre par statut
    if (_selectedStatus != 'Tous') {
      filtered = filtered.where((order) => order.status == _selectedStatus).toList();
    }

    // Filtre par période
    final now = DateTime.now();
    switch (_selectedFilter) {
      case 'Aujourd\'hui':
        filtered = filtered.where((order) =>
        order.orderDate.year == now.year &&
            order.orderDate.month == now.month &&
            order.orderDate.day == now.day
        ).toList();
        break;
      case 'Cette semaine':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        filtered = filtered.where((order) =>
            order.orderDate.isAfter(startOfWeek.subtract(const Duration(days: 1)))
        ).toList();
        break;
      case 'Ce mois':
        filtered = filtered.where((order) =>
        order.orderDate.year == now.year &&
            order.orderDate.month == now.month
        ).toList();
        break;
      default:
        break;
    }

    return filtered;
  }

  Map<String, int> get _statusCount {
    final Map<String, int> count = {};
    for (var order in _orders) {
      count[order.status] = (count[order.status] ?? 0) + 1;
    }
    return count;
  }

  Future<void> _updateOrderStatus(Order order, String newStatus) async {
    setState(() {
      order.status = newStatus;
    });

    _showSnackBar("Commande ${order.id} : ${_getStatusMessage(newStatus)}", Colors.green);

    // Simuler un appel API
    await Future.delayed(const Duration(milliseconds: 500));
  }

  String _getStatusMessage(String status) {
    switch (status) {
      case 'Confirmée':
        return 'confirmée ✅';
      case 'En préparation':
        return 'en préparation 👨‍🍳';
      case 'Prête':
        return 'prête à être livrée 📦';
      case 'Livrée':
        return 'livrée 🚚';
      case 'Annulée':
        return 'annulée ❌';
      default:
        return 'mise à jour';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'En attente':
        return Colors.orange;
      case 'Confirmée':
        return Colors.blue;
      case 'En préparation':
        return Colors.purple;
      case 'Prête':
        return Colors.teal;
      case 'Livrée':
        return Colors.green;
      case 'Annulée':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showOrderDetails(Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderDetailsSheet(order: order, onStatusUpdate: _updateOrderStatus),
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
          "Commandes",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _loadOrders,
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Color(0xFF4A2C2A)),
      )
          : Column(
        children: [
          // Statistiques rapides
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _statusOptions.length,
              itemBuilder: (context, index) {
                final status = _statusOptions[index];
                final count = _statusCount[status] ?? 0;
                final isSelected = _selectedStatus == status;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedStatus = status;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF4A2C2A) : const Color(0xFFF8DADA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          count.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : const Color(0xFF4A2C2A),
                          ),
                        ),
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 11,
                            color: isSelected ? Colors.white70 : const Color(0xFF4A2C2A).withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Filtres période
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text(
                  "Période :",
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

          // Liste des commandes
          Expanded(
            child: _filteredOrders.isEmpty
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
                    child: const Icon(
                      Icons.receipt_long_outlined,
                      size: 60,
                      color: Color(0xFF4A2C2A),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Aucune commande",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A2C2A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _selectedStatus != 'Tous'
                        ? "Aucune commande $_selectedStatus.toLowerCase()"
                    : "Aucune commande pour cette période",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredOrders.length,
              itemBuilder: (context, index) {
                final order = _filteredOrders[index];
                return _buildOrderCard(order);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    final dateFormat = DateFormat('dd/MM/yyyy à HH:mm');

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
          onTap: () => _showOrderDetails(order),
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.id,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A2C2A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.clientName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        order.status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(order.status),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Détails
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      "Commandé le ${dateFormat.format(order.orderDate)}",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                if (order.deliveryTime != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.delivery_dining, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        "Livraison prévue : ${dateFormat.format(order.deliveryTime!)}",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),

                // Produits
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: order.items.map((item) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8DADA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${item.quantity}x ${item.name}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4A2C2A),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),

                // Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "${order.total.toStringAsFixed(2)} €",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A2C2A),
                      ),
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

// Widget pour les détails de la commande en bas de page
class OrderDetailsSheet extends StatefulWidget {
  final Order order;
  final Function(Order, String) onStatusUpdate;

  const OrderDetailsSheet({
    super.key,
    required this.order,
    required this.onStatusUpdate,
  });

  @override
  State<OrderDetailsSheet> createState() => _OrderDetailsSheetState();
}

class _OrderDetailsSheetState extends State<OrderDetailsSheet> {
  String _selectedStatus = '';

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.order.status;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy à HH:mm');

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              // Titre
              const Text(
                "Détails de la commande",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2C2A),
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Infos client
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8DADA),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.person, size: 20, color: Color(0xFF4A2C2A)),
                              SizedBox(width: 8),
                              Text(
                                "Client",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4A2C2A),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(widget.order.clientName),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.phone, size: 16, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(widget.order.clientPhone),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on, size: 16, color: Colors.grey),
                              const SizedBox(width: 8),
                              Expanded(child: Text(widget.order.clientAddress)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Produits commandés
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8DADA),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.shopping_bag, size: 20, color: Color(0xFF4A2C2A)),
                              SizedBox(width: 8),
                              Text(
                                "Produits commandés",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4A2C2A),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.order.items.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, index) {
                              final item = widget.order.items[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${item.quantity}x ${item.name}",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    Text(
                                      "${(item.price * item.quantity).toStringAsFixed(2)} €",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF4A2C2A),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4A2C2A),
                                  ),
                                ),
                                Text(
                                  "${widget.order.total.toStringAsFixed(2)} €",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4A2C2A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Horaires
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8DADA),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Horaires",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A2C2A),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text("Commandé : ${dateFormat.format(widget.order.orderDate)}"),
                            ],
                          ),
                          if (widget.order.deliveryTime != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.delivery_dining, size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text("Livraison : ${dateFormat.format(widget.order.deliveryTime!)}"),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Changement de statut
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8DADA),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Statut de la commande",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A2C2A),
                            ),
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: _selectedStatus,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'En attente', child: Text('En attente')),
                              DropdownMenuItem(value: 'Confirmée', child: Text('Confirmée')),
                              DropdownMenuItem(value: 'En préparation', child: Text('En préparation')),
                              DropdownMenuItem(value: 'Prête', child: Text('Prête')),
                              DropdownMenuItem(value: 'Livrée', child: Text('Livrée')),
                              DropdownMenuItem(value: 'Annulée', child: Text('Annulée')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedStatus = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                widget.onStatusUpdate(widget.order, _selectedStatus);
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4A2C2A),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text("Mettre à jour le statut"),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Modèles de données
class Order {
  final String id;
  final String clientName;
  final String clientPhone;
  final String clientAddress;
  final List<OrderItem> items;
  final double total;
  String status;
  final DateTime orderDate;
  final DateTime? deliveryTime;

  Order({
    required this.id,
    required this.clientName,
    required this.clientPhone,
    required this.clientAddress,
    required this.items,
    required this.total,
    required this.status,
    required this.orderDate,
    this.deliveryTime,
  });
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}