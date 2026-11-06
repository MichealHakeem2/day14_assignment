import 'package:shopping_app/core/database/sqflite_helper.dart';
import 'package:shopping_app/features/cart/data/models/cart_item_model.dart';
import 'package:sqflite/sqflite.dart';

class CartLocalDataSource {
  final SqfliteHelper dbHelper;

  CartLocalDataSource({SqfliteHelper? dbHelper})
      : dbHelper = dbHelper ?? SqfliteHelper.instance;

  Future<List<CartItemModel>> getCart() async {
    final db = await dbHelper.database;
    final results = await db.query('cart', orderBy: 'id DESC');
    return results.map((map) => CartItemModel.fromMap(map)).toList();
  }

  Future<void> addToCart(CartItemModel item) async {
    final db = await dbHelper.database;
    final existing = await db.query(
      'cart',
      where: 'productId = ?',
      whereArgs: [item.productId],
    );

    if (existing.isNotEmpty) {
      final currentQuantity = (existing.first['quantity'] as num?)?.toInt() ?? 1;
      await db.update(
        'cart',
        {'quantity': currentQuantity + item.quantity},
        where: 'productId = ?',
        whereArgs: [item.productId],
      );
    } else {
      await db.insert(
        'cart',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    final db = await dbHelper.database;
    if (quantity <= 0) {
      await deleteFromCart(productId);
    } else {
      await db.update(
        'cart',
        {'quantity': quantity},
        where: 'productId = ?',
        whereArgs: [productId],
      );
    }
  }

  Future<void> deleteFromCart(int productId) async {
    final db = await dbHelper.database;
    await db.delete(
      'cart',
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  Future<void> clearCart() async {
    final db = await dbHelper.database;
    await db.delete('cart');
  }

  Future<void> cacheCartItems(List<CartItemModel> items) async {
    final db = await dbHelper.database;
    final batch = db.batch();
    for (var item in items) {
      batch.insert(
        'cart',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}

