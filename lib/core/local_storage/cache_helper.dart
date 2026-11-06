import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/core/database/sqflite_helper.dart';
import 'package:sqflite/sqflite.dart';

class CacheHelper {
  static String? token;
  static String? userEmail;
  static String? userName;

  static void saveToken(String userToken) {
    token = userToken;
    _persistToken(userToken);
  }

  static String? getToken() {
    return token;
  }

  static bool hasToken() {
    return token != null && token!.isNotEmpty;
  }

  static void clear() {
    token = null;
    userEmail = null;
    userName = null;
    _clearPersistedToken();
  }

  static Future<void> _persistToken(String userToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', userToken);
      if (userName != null) await prefs.setString('name', userName!);
      if (userEmail != null) await prefs.setString('email', userEmail!);
    } catch (_) {}

    try {
      final db = await SqfliteHelper.instance.database;
      await db.delete('users');
      await db.insert('users', {
        'name': userName ?? '',
        'email': userEmail ?? '',
        'phone': '',
        'token': userToken,
      });
      await db.insert(
        'user_profile',
        {
          'id': 'current',
          'name': userName ?? '',
          'email': userEmail ?? '',
          'phone': '',
          'address': '',
          'image': '',
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (_) {}
  }

  static Future<void> _clearPersistedToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('name');
      await prefs.remove('email');
    } catch (_) {}

    try {
      final db = await SqfliteHelper.instance.database;
      await db.delete('users');
      await db.delete('user_profile');
      await db.delete('cart');
      await db.delete('favorites');
    } catch (_) {}
  }

  static Future<void> loadTokenFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token');
      userName = prefs.getString('name');
      userEmail = prefs.getString('email');
      if (token != null && token!.isNotEmpty) return;
    } catch (_) {}

    try {
      final db = await SqfliteHelper.instance.database;
      final results = await db.query('users', limit: 1);
      if (results.isNotEmpty) {
        token = results.first['token'] as String?;
        userName = results.first['name'] as String?;
        userEmail = results.first['email'] as String?;
      }
    } catch (_) {}
  }
}
