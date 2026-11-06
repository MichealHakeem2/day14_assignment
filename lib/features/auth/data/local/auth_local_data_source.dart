import 'package:shopping_app/core/database/sqflite_helper.dart';
import 'package:shopping_app/features/auth/data/models/user_model.dart';

class AuthLocalDataSource {
  final SqfliteHelper dbHelper;

  AuthLocalDataSource({SqfliteHelper? dbHelper})
      : dbHelper = dbHelper ?? SqfliteHelper.instance;

  Future<void> saveUser(UserModel user) async {
    final db = await dbHelper.database;
    await db.delete('users');
    await db.insert('users', user.toMap());
  }

  Future<UserModel?> getUser() async {
    final db = await dbHelper.database;
    final results = await db.query('users', limit: 1);

    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }
    return null;
  }

  Future<void> clearUser() async {
    final db = await dbHelper.database;
    await db.delete('users');
  }
}
