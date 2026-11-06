class CartItemModel {
  final int? id;
  final int productId;
  final String title;
  final double price;
  final String image;
  int quantity;

  CartItemModel({
    this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    int pId = 0;
    String t = '';
    double p = 0.0;
    String img = '';
    int q = 1;

    if (json.containsKey('product') && json['product'] is Map) {
      final prod = json['product'] as Map<String, dynamic>;
      pId = (prod['id'] as num?)?.toInt() ?? 0;
      t = prod['title']?.toString() ?? '';
      p = (prod['price'] as num?)?.toDouble() ?? 0.0;
      img = prod['thumbnail']?.toString() ?? prod['image']?.toString() ?? '';
      q = (json['quantity'] as num?)?.toInt() ?? 1;
    } else {
      pId = (json['productId'] as num?)?.toInt() ?? (json['id'] as num?)?.toInt() ?? 0;
      t = json['title']?.toString() ?? '';
      p = (json['price'] as num?)?.toDouble() ?? 0.0;
      img = json['image']?.toString() ?? json['thumbnail']?.toString() ?? '';
      q = (json['quantity'] as num?)?.toInt() ?? 1;
    }

    return CartItemModel(
      id: json['id'] as int?,
      productId: pId,
      title: t,
      price: p,
      image: img,
      quantity: q > 0 ? q : 1,
    );
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id'] as int?,
      productId: map['productId'] as int,
      title: map['title'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      image: map['image'] as String? ?? '',
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'productId': productId,
      'title': title,
      'price': price,
      'image': image,
      'quantity': quantity,
    };
  }
}

