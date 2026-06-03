class ProductModel {
  final String id;
  final String name;
  final int price;
  final String currency;
  final String image;
  final double rating;
  final String category;
  final String description;
  bool isFavorite;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.image,
    required this.rating,
    required this.category,
    required this.description,
    required this.isFavorite,
  });

  String get formattedPrice => "$price $currency";

  // Convertir l'objet en Map (pour sauvegarder dans SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'currency': currency,
      'image': image,
      'rating': rating,
      'category': category,
      'description': description,
      'isFavorite': isFavorite,
    };
  }

  // Créer un objet depuis une Map (pour lire depuis SharedPreferences)
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      currency: json['currency'],
      image: json['image'],
      rating: json['rating'].toDouble(),
      category: json['category'],
      description: json['description'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}