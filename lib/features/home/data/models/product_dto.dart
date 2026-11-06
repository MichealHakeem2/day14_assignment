import 'package:shopping_app/features/home/domain/entities/product_entity.dart';

class ProductDto {
  final int id;
  final String title;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> images;

  ProductDto({
    required this.id,
    required this.title,
    required this.price,
    this.discountPercentage = 0.0,
    this.rating = 0.0,
    this.stock = 0,
    this.images = const [],
  });

  // fromJson
  factory ProductDto.fromJson(Map<String, dynamic> json) {
    List<String> imgs = [];
    if (json['images'] is List) {
      imgs = (json['images'] as List).map((e) => e.toString()).toList();
    } else if (json['thumbnail'] != null && json['thumbnail'].toString().isNotEmpty) {
      imgs = [json['thumbnail'].toString()];
    } else if (json['image'] != null && json['image'].toString().isNotEmpty) {
      imgs = [json['image'].toString()];
    }

    return ProductDto(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ??
          (json['discount'] as num?)?.toDouble() ??
          0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      images: imgs,
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'images': images,
    };
  }

  // convert DTO to Entity
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      title: title,
      price: price,
      discountPercentage: discountPercentage,
      rating: rating,
      stock: stock,
      images: images,
    );
  }
}

