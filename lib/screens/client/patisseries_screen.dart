import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../cart_screen.dart';
import 'cart_screen.dart';

class PatisseriesScreen extends StatefulWidget {
  const PatisseriesScreen({super.key});

  @override
  State<PatisseriesScreen> createState() => _PatisseriesScreenState();
}

class _PatisseriesScreenState extends State<PatisseriesScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Toutes';

  // Liste des catégories de boutiques
  final List<String> _categories = [
    'Toutes',
    'Pâtisseries',
    'Boulangeries',
    'Cafés',
    'Pâtisseries Orientales',
    'Glaciers',
    'Traiteurs',
  ];

  // Liste des boutiques de pâtisseries
  final List<PatisserieShop> _shops = [
    PatisserieShop(
      id: '1',
      name: "La Maison du Chocolat",
      ownerName: "Marie Lambert",
      address: "123 Avenue de la Pâtisserie, Douala",
      phone: "+237 6 12 34 56 78",
      email: "contact@maisonchocolat.cm",
      category: "Pâtisseries",
      rating: 4.9,
      image: "assets/shop1.png",
      description: "Spécialiste du chocolat et des pâtisseries fines depuis 1995.",
      deliveryTime: "30-45 min",
      deliveryFee: 500,
      isOpen: true,
      isFavorite: false,
      products: ["Gâteau au chocolat", "Éclairs", "Macarons", "Truffes"],
    ),
    PatisserieShop(
      id: '2',
      name: "Boulangerie des Délices",
      ownerName: "Jean-Pierre Dubois",
      address: "45 Rue des Pains, Yaoundé",
      phone: "+237 6 98 76 54 32",
      email: "contact@delices.cm",
      category: "Boulangeries",
      rating: 4.7,
      image: "assets/shop2.png",
      description: "Pains frais et viennoiseries artisanales chaque matin.",
      deliveryTime: "20-35 min",
      deliveryFee: 300,
      isOpen: true,
      isFavorite: false,
      products: ["Baguette", "Croissant", "Pain au chocolat", "Brioche"],
    ),
    PatisserieShop(
      id: '3',
      name: "Douceurs Sucrées",
      ownerName: "Sophie Martin",
      address: "78 Boulevard des Gourmands, Douala",
      phone: "+237 6 55 44 33 22",
      email: "contact@douceurs.cm",
      category: "Pâtisseries",
      rating: 4.8,
      image: "assets/shop3.png",
      description: "Cupcakes, cookies et gâteaux personnalisés pour tous vos événements.",
      deliveryTime: "25-40 min",
      deliveryFee: 600,
      isOpen: true,
      isFavorite: true,
      products: ["Cupcake", "Cookies", "Cheesecake", "Brownies"],
    ),
    PatisserieShop(
      id: '4',
      name: "Café Pâtisserie L'Éclair",
      ownerName: "Thomas Bernard",
      address: "12 Place Centrale, Yaoundé",
      phone: "+237 6 11 22 33 44",
      email: "contact@leclair.cm",
      category: "Cafés",
      rating: 4.6,
      image: "assets/shop4.png",
      description: "Cafés spécialités et pâtisseries françaises dans un cadre chaleureux.",
      deliveryTime: "15-30 min",
      deliveryFee: 400,
      isOpen: false,
      isFavorite: false,
      products: ["Café latte", "Mille-feuille", "Opéra", "Thé"],
    ),
    PatisserieShop(
      id: '5',
      name: "Pâtisserie Orientale",
      ownerName: "Fatima Al-Hassan",
      address: "67 Rue de la Liberté, Douala",
      phone: "+237 6 77 88 99 00",
      email: "contact@orientale.cm",
      category: "Pâtisseries Orientales",
      rating: 4.9,
      image: "assets/shop5.png",
      description: "Baklava, cornes de gazelle et délices orientaux authentiques.",
      deliveryTime: "35-50 min",
      deliveryFee: 700,
      isOpen: true,
      isFavorite: false,
      products: ["Baklava", "Cornes de gazelle", "Briouats", "Samsa"],
    ),
    PatisserieShop(
      id: '6',
      name: "Glacier Artisanal",
      ownerName: "Marc Laurent",
      address: "34 Avenue des Glaces, Yaoundé",
      phone: "+237 6 44 55 66 77",
      email: "contact@glacier.cm",
      category: "Glaciers",
      rating: 4.8,
      image: "assets/shop6.png",
      description: "Glaces artisanales aux parfums originaux et sorbets fruités.",
      deliveryTime: "20-35 min",
      deliveryFee: 500,
      isOpen: true,
      isFavorite: true,
      products: ["Glace vanille", "Sorbet citron", "Coupe glacée", "Milk-shake"],
    ),
    PatisserieShop(
      id: '7',
      name: "Traiteur des Rois",
      ownerName: "Robert Kamga",
      address: "89 Rue des Fêtes, Douala",
      phone: "+237 6 99 00 11 22",
      email: "contact@traiteurdesrois.cm",
      category: "Traiteurs",
      rating: 4.7,
      image: "assets/shop7.png",
      description: "Traiteur pour mariages, anniversaires et événements spéciaux.",
      deliveryTime: "45-60 min",
      deliveryFee: 1000,
      isOpen: true,
      isFavorite: false,
      products: ["Buffet sucré", "Gâteaux de mariage", "Mignardises", "Desserts"],
    ),
    PatisserieShop(
      id: '8',
      name: "Le Moulin de la Farine",
      ownerName: "Claire Dupont",
      address: "56 Rue des Moulins, Yaoundé",
      phone: "+237 6 22 33 44 55",
      email: "contact@lemoulin.cm",
      category: "Boulangeries",
      rating: 4.5,
      image: "assets/shop8.png",
      description: "Boulangerie traditionnelle au levain naturel.",
      deliveryTime: "25-40 min",
      deliveryFee: 400,
      isOpen: false,
      isFavorite: false,
      products: ["Pain complet", "Pain de seigle", "Baguette tradition", "Pain aux céréales"],
    ),
    PatisserieShop(
      id: '9',
      name: "Pâtisserie Royale",
      ownerName: "Élisabeth Ngono",
      address: "101 Boulevard Présidentiel, Douala",
      phone: "+237 6 55 66 77 88",
      email: "contact@royale.cm",
      category: "Pâtisseries",
      rating: 4.9,
      image: "assets/shop9.png",
      description: "Pâtisseries haut de gamme pour occasions spéciales.",
      deliveryTime: "30-45 min",
      deliveryFee: 800,
      isOpen: true,
      isFavorite: true,
      products: ["Pièce montée", "Croquembouche", "Gâteau royal", "Mille-feuille"],
    ),
    PatisserieShop(
      id: '10',
      name: "Café Gourmet",
      ownerName: "Pauline Kameni",
      address: "23 Rue des Artistes, Yaoundé",
      phone: "+237 6 88 99 00 11",
      email: "contact@cafegourmet.cm",
      category: "Cafés",
      rating: 4.6,
      image: "assets/shop10.png",
      description: "Café de spécialité et pâtisseries fines.",
      deliveryTime: "15-25 min",
      deliveryFee: 300,
      isOpen: true,
      isFavorite: false,
      products: ["Espresso", "Cappuccino", "Latte art", "Café viennois"],
    ),
  ];

  // Panier
  int _cartCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCartCount();
  }

  // ✅ METHODE CORRIGÉE
  Future<void> _loadCartCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? cartJson = prefs.getString('cart');

      // Vérification sécurisée
      if (cartJson == null || cartJson.isEmpty || cartJson == 'null' || cartJson == '[]') {
        setState(() {
          _cartCount = 0;
        });
        return;
      }

      final decoded = jsonDecode(cartJson);

      // Vérifier que decoded est bien une liste
      if (decoded is! List) {
        setState(() {
          _cartCount = 0;
        });
        return;
      }

      int count = 0;
      for (var item in decoded) {
        if (item is Map) {
          int quantity = item['quantity'] ?? 0;
          count += quantity;
        }
      }

      setState(() {
        _cartCount = count;
      });
    } catch (e) {
      print("Erreur lors du chargement du panier: $e");
      setState(() {
        _cartCount = 0;
      });
    }
  }

  List<PatisserieShop> get _filteredShops {
    List<PatisserieShop> filtered = _shops;

    // Filtre par catégorie
    if (_selectedCategory != 'Toutes') {
      filtered = filtered.where((s) => s.category == _selectedCategory).toList();
    }

    // Filtre par recherche
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((s) => s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.ownerName.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  void _toggleFavorite(PatisserieShop shop) {
    setState(() {
      shop.isFavorite = !shop.isFavorite;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(shop.isFavorite ? "Ajouté aux favoris ❤️" : "Retiré des favoris 💔"),
        backgroundColor: shop.isFavorite ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _viewShopDetails(PatisserieShop shop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ShopDetailsSheet(shop: shop),
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
          "Pâtisseries",
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
          _buildCategoryFilter(),
          Expanded(
            child: _filteredShops.isEmpty
                ? _buildEmptyState()
                : _buildShopsList(),
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
            hintText: "Rechercher une pâtisserie...",
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

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              backgroundColor: Colors.grey.shade100,
              selectedColor: const Color(0xFF4A2C2A),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF4A2C2A),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? const Color(0xFF4A2C2A) : Colors.grey.shade300,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShopsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredShops.length,
      itemBuilder: (context, index) {
        final shop = _filteredShops[index];
        return ShopCard(
          shop: shop,
          onFavoriteToggle: () => _toggleFavorite(shop),
          onTap: () => _viewShopDetails(shop),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            "Aucune pâtisserie trouvée",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Essayez une autre recherche ou catégorie",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

// Modèle de boutique de pâtisserie
class PatisserieShop {
  final String id;
  final String name;
  final String ownerName;
  final String address;
  final String phone;
  final String email;
  final String category;
  final double rating;
  final String image;
  final String description;
  final String deliveryTime;
  final int deliveryFee;
  final bool isOpen;
  bool isFavorite;
  final List<String> products;

  PatisserieShop({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.address,
    required this.phone,
    required this.email,
    required this.category,
    required this.rating,
    required this.image,
    required this.description,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.isOpen,
    required this.isFavorite,
    required this.products,
  });
}

// Widget Carte Boutique
class ShopCard extends StatelessWidget {
  final PatisserieShop shop;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const ShopCard({
    super.key,
    required this.shop,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
        child: Column(
          children: [
            // Image et en-tête
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.asset(
                    shop.image,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150,
                        color: const Color(0xFFF8DADA),
                        child: const Center(
                          child: Icon(
                            Icons.store,
                            size: 60,
                            color: Color(0xFF4A2C2A),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Badge ouvert/fermé
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: shop.isOpen ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      shop.isOpen ? "OUVERT" : "FERMÉ",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Bouton favori
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: Container(
                      padding: const EdgeInsets.all(8),
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
                        shop.isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: shop.isFavorite ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Informations
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          shop.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF4A2C2A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.amber.shade700),
                          const SizedBox(width: 4),
                          Text(
                            shop.rating.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    shop.category,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          shop.address,
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.delivery_dining, size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(
                        shop.deliveryTime,
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.motorcycle, size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(
                        "${shop.deliveryFee} FCFA",
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
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

// Feuille de détails de la boutique
class ShopDetailsSheet extends StatelessWidget {
  final PatisserieShop shop;

  const ShopDetailsSheet({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(shop.image),
                backgroundColor: const Color(0xFFF8DADA),
                child: shop.image.isEmpty
                    ? const Icon(Icons.store, size: 40, color: Color(0xFF4A2C2A))
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A2C2A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      shop.category,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber.shade700),
                        const SizedBox(width: 4),
                        Text(shop.rating.toString()),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 10),
          Text(
            "À propos",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4A2C2A),
            ),
          ),
          const SizedBox(height: 8),
          Text(shop.description),
          const SizedBox(height: 15),
          Text(
            "Contact",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4A2C2A),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(shop.ownerName),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.phone, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(shop.phone),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.email, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(shop.email),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            "Produits populaires",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4A2C2A),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: shop.products.map((product) {
              return Chip(
                label: Text(product),
                backgroundColor: const Color(0xFFF8DADA),
                labelStyle: const TextStyle(color: Color(0xFF4A2C2A)),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Page de ${shop.name} en cours de développement"),
                    backgroundColor: const Color(0xFF4A2C2A),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A2C2A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("VOIR LA CARTE"),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}