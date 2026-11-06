import 'package:shopping_app/features/home/domain/entities/product_entity.dart';

class ProductModel {
  final int id;
  final String title;
  final double price;
  final String image;
  final String description;
  final String category;
  final String brand;
  final double rating;
  final int stock;
  final double discountPercentage;
  final List<String> images;
  bool isFavorite;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    this.description = '',
    this.category = '',
    this.brand = '',
    this.rating = 0.0,
    this.stock = 0,
    this.discountPercentage = 0.0,
    this.images = const [],
    this.isFavorite = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> rawJson) {
    final json = rawJson['product'] is Map<String, dynamic>
        ? rawJson['product'] as Map<String, dynamic>
        : rawJson;
    String img = '';
    if (json['thumbnail'] != null && json['thumbnail'].toString().isNotEmpty) {
      img = json['thumbnail'].toString();
    } else if (json['image'] != null && json['image'].toString().isNotEmpty) {
      img = json['image'].toString();
    } else if (json['images'] is List && (json['images'] as List).isNotEmpty) {
      img = (json['images'] as List).first.toString();
    }

    List<String> imgs = [];
    if (json['images'] is List) {
      imgs = (json['images'] as List).map((e) => e.toString()).toList();
    }
    if (imgs.isEmpty && img.isNotEmpty) {
      imgs = [img];
    }

    return ProductModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: img,
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      images: imgs,
      isFavorite: json['isFavorite'] == 1 || json['isFavorite'] == true,
    );
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int,
      title: map['title'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      image: map['image'] as String? ?? '',
      description: map['description'] as String? ?? '',
      category: map['category'] as String? ?? '',
      brand: map['brand'] as String? ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      stock: (map['stock'] as num?)?.toInt() ?? 0,
      discountPercentage: (map['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      images: map['image'] != null && (map['image'] as String).isNotEmpty
          ? [map['image'] as String]
          : [],
      isFavorite: map['isFavorite'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'image': image,
      'description': description,
      'category': category,
      'brand': brand,
      'rating': rating,
      'stock': stock,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      title: title,
      price: price,
      discountPercentage: discountPercentage,
      rating: rating,
      stock: stock,
      images: images,
      isFavorite: isFavorite,
    );
  }
}
