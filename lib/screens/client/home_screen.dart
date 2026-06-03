import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/product_model.dart';
import '../role_choice_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'favorites_screen.dart';
import 'products_screen.dart';
import 'patisseries_screen.dart';
import 'order_screen.dart';
import 'settings_screen.dart';
import 'event_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeClientScreenState();
}

class _HomeClientScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  int _cartCount = 0;

  final List<CategoryModel> _categories = [
    CategoryModel(icon: Icons.cake, label: "Gâteaux", color: const Color(0xFF4A2C2A)),
    CategoryModel(icon: Icons.icecream, label: "Glaces", color: const Color(0xFFE91E63)),
    CategoryModel(icon: Icons.local_cafe, label: "Boissons", color: const Color(0xFF795548)),
    CategoryModel(icon: Icons.fastfood, label: "Snacks", color: const Color(0xFFFF9800)),
    CategoryModel(icon: Icons.bakery_dining, label: "Pains", color: const Color(0xFF8D6E63)),
    CategoryModel(icon: Icons.egg_alt, label: "Tartes", color: const Color(0xFFFF6B6B)),
  ];

  // ✅ Utilisation UNIQUEMENT de EventData
  final List<EventData> _events = [
    EventData(
      icon: Icons.celebration,
      label: "Mariage",
      color: const Color(0xFFE91E63),
      description: "Gâteaux personnalisés",
      fullDescription: "Nous créons des gâteaux de mariage uniques et élégants pour votre jour spécial.",
      offers: ["🍰 Gâteaux à plusieurs étages", "🎂 Dégustation gratuite", "🚚 Livraison le jour J"],
      galleryImages: ["assets/mariage1.png"],
    ),
    EventData(
      icon: Icons.cake,
      label: "Anniversaire",
      color: const Color(0xFFFF9800),
      description: "Bougies personnalisées",
      fullDescription: "Fêtez votre anniversaire avec nos créations uniques !",
      offers: ["🎂 Gâteaux personnalisés", "🕯️ Bougies spéciales", "⭐ Toppers personnalisés"],
      galleryImages: ["assets/anniv1.png"],
    ),
    EventData(
      icon: Icons.work,
      label: "Anniversaire de mariage",
      color: const Color(0xFF9C27B0),
      description: "Surprise garantie",
      fullDescription: "Célébrez vos années d'amour avec un gâteau exceptionnel.",
      offers: ["💖 Design personnalisé", "💌 Message d'amour", "🎁 Livraison surprise"],
      galleryImages: ["assets/mariage1.png"],
    ),
    EventData(
      icon: Icons.card_giftcard,
      label: "Baby Shower",
      color: const Color(0xFF4CAF50),
      description: "Douceurs inoubliables",
      fullDescription: "Accueillez le nouveau-né avec nos créations adorables.",
      offers: ["👶 Thème fille/garçon", "🧁 Cupcakes assortis", "🍪 Cookies personnalisés"],
      galleryImages: ["assets/baby1.png"],
    ),
    EventData(
      icon: Icons.business_center,
      label: "Entreprise",
      color: const Color(0xFF2196F3),
      description: "Commandes en gros",
      fullDescription: "Pour vos événements d'entreprise, réunions ou cadeaux d'affaires.",
      offers: ["🏢 Logo personnalisé", "📦 Commandes groupées", "🚚 Livraison au bureau"],
      galleryImages: ["assets/entreprise1.png"],
    ),
  ];

  final List<ProductModel> _popularProducts = [
    ProductModel(
      id: '1',
      name: "Cupcake Chocolat",
      price: 2500,
      currency: "FCFA",
      image: "assets/cupcake1.png",
      rating: 4.8,
      category: "Gâteaux",
      description: "Délicieux cupcake au chocolat fondant.",
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
      description: "Cupcake à la vanille de Madagascar.",
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
      description: "Donut recouvert d'un glaçage sucré.",
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
      description: "Tarte fraîche aux fraises.",
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
  ];

  @override
  void initState() {
    super.initState();
    _loadCartCount();
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

  List<ProductModel> get _filteredProducts {
    if (_searchQuery.isEmpty) return _popularProducts;
    return _popularProducts
        .where((product) => product.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RoleChoiceScreen()),
      );
    }
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

  void _navigateToScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    ).then((_) {
      _loadCartCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "BAKEE",
          style: TextStyle(
            color: Color(0xFF4A2C2A),
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1,
          ),
        ),
        centerTitle: false,
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
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout, color: Color(0xFF4A2C2A)),
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF4A2C2A),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, "Accueil", 0),
            _buildNavItem(Icons.shopping_bag, "Produits", 1),
            _buildNavItem(Icons.bakery_dining, "Pâtisseries", 2),
            _buildNavItem(Icons.receipt, "Commande", 3),
            _buildNavItem(Icons.settings, "Paramètre", 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        switch (index) {
          case 0:
            break;
          case 1:
            _navigateToScreen(const ProductsScreen());
            break;
          case 2:
            _navigateToScreen(const PatisseriesScreen());
            break;
          case 3:
            _navigateToScreen(const OrderScreen());
            break;
          case 4:
            _navigateToScreen(const SettingsScreen());
            break;
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected ? [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ] : [],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF4A2C2A) : Colors.white,
              size: 20,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: const Color(0xFF4A2C2A),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _buildSearchBar(),
          const SizedBox(height: 20),
          _buildCakeCounter(),
          const SizedBox(height: 20),
          _buildEventsSection(),
          const SizedBox(height: 20),
          _buildCategoriesSection(),
          const SizedBox(height: 20),
          _buildPopularProductsSection(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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

  Widget _buildCakeCounter() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A2C2A), Color(0xFF6B3A2A)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "🍰 Notre sélection",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${_popularProducts.length}+",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const TextSpan(
                      text: " gâteaux disponibles",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.celebration,
              size: 40,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ SECTION DES ÉVÉNEMENTS CORRIGÉE
  Widget _buildEventsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "🎉 Événements spéciaux",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A2C2A),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _events.length,
            itemBuilder: (context, index) {
              final EventData event = _events[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventDetailScreen(event: event),
                    ),
                  );
                },
                child: EventCard(event: event),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Catégories",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A2C2A),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              return CategoryItem(category: _categories[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Populaires",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2C2A),
                ),
              ),
              TextButton(
                onPressed: () {
                  _navigateToScreen(const ProductsScreen());
                },
                child: const Text(
                  "Voir tout",
                  style: TextStyle(color: Color(0xFF4A2C2A)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _searchQuery.isNotEmpty
            ? _buildSearchResults()
            : SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _popularProducts.length,
            itemBuilder: (context, index) {
              return ProductCard(
                product: _popularProducts[index],
                onFavoriteToggle: () {
                  setState(() {
                    _popularProducts[index].isFavorite =
                    !_popularProducts[index].isFavorite;
                  });
                  _showSnackBar(
                    _popularProducts[index].isFavorite
                        ? "Ajouté aux favoris ❤️"
                        : "Retiré des favoris 💔",
                    _popularProducts[index].isFavorite
                        ? Colors.green
                        : Colors.red,
                  );
                },
                onAddToCart: () {
                  _showSnackBar(
                    "${_popularProducts[index].name} ajouté au panier 🛒",
                    Colors.green,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_filteredProducts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
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
        ),
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "${_filteredProducts.length} résultat(s) trouvé(s)",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              return ProductCard(
                product: _filteredProducts[index],
                onFavoriteToggle: () {
                  setState(() {
                    _filteredProducts[index].isFavorite =
                    !_filteredProducts[index].isFavorite;
                  });
                },
                onAddToCart: () {
                  _showSnackBar(
                    "${_filteredProducts[index].name} ajouté au panier 🛒",
                    Colors.green,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// ================= MODÈLE CATÉGORIE =================
class CategoryModel {
  final IconData icon;
  final String label;
  final Color color;

  CategoryModel({
    required this.icon,
    required this.label,
    required this.color,
  });
}

// ================= WIDGET ÉVÉNEMENT (CORRIGÉ - Utilise EventData) =================
class EventCard extends StatelessWidget {
  final EventData event;  // ⭐ Utilise EventData, PAS EventModel

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            event.color.withOpacity(0.2),
            event.color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: event.color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(event.icon, size: 32, color: event.color),
          const SizedBox(height: 8),
          Text(
            event.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: event.color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            event.description,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ================= WIDGET CATÉGORIE =================
class CategoryItem extends StatelessWidget {
  final CategoryModel category;

  const CategoryItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  category.color.withOpacity(0.2),
                  category.color.withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              child: Icon(
                category.icon,
                color: category.color,
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4A2C2A),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ================= WIDGET PRODUIT =================
class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onFavoriteToggle,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
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
                    height: 100,
                    width: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 100,
                        width: 120,
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
              onTap: onFavoriteToggle,
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
              onTap: onAddToCart,
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
    );
  }
}