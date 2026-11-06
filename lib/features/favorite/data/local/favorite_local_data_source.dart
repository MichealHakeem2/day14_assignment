import 'package:shopping_app/core/database/sqflite_helper.dart';
import 'package:shopping_app/features/home/data/models/product_model.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteLocalDataSource {
  final SqfliteHelper dbHelper;

  FavoriteLocalDataSource({SqfliteHelper? dbHelper})
      : dbHelper = dbHelper ?? SqfliteHelper.instance;

  Future<List<ProductModel>> getFavorites() async {
    final db = await dbHelper.database;
    final results = await db.query('favorites');

    return results.map((map) {
      return ProductModel(
        id: map['productId'] as int,
        title: map['title'] as String? ?? '',
        price: (map['price'] as num?)?.toDouble() ?? 0.0,
        image: map['image'] as String? ?? '',
        category: map['category'] as String? ?? '',
        isFavorite: true,
      );
    }).toList();
  }

  Future<bool> isFavorite(int productId) async {
    final db = await dbHelper.database;
    final results = await db.query(
      'favorites',
      where: 'productId = ?',
      whereArgs: [productId],
    );
    return results.isNotEmpty;
  }

  Future<void> addFavorite(ProductModel product) async {
    final db = await dbHelper.database;
    await db.insert(
      'favorites',
      {
        'productId': product.id,
        'title': product.title,
        'price': product.price,
        'image': product.image,
        'category': product.category,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.update(
      'products',
      {'isFavorite': 1},
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<void> deleteFavorite(int productId) async {
    final db = await dbHelper.database;
    await db.delete(
      'favorites',
      where: 'productId = ?',
      whereArgs: [productId],
    );

    await db.update(
      'products',
      {'isFavorite': 0},
      where: 'id = ?',
      whereArgs: [productId],
    );
  }
}

