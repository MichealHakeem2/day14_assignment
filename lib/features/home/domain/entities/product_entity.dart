class ProductEntity {
  final int id;
  final String title;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> images;
  bool isFavorite;

  ProductEntity({
    required this.id,
    required this.title,
    required this.price,
    this.discountPercentage = 0.0,
    this.rating = 0.0,
    this.stock = 0,
    this.images = const [],
    this.isFavorite = false,
  });

  String get image => images.isNotEmpty ? images.first : '';
}

