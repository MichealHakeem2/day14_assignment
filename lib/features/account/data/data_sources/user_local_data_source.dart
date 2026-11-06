import 'package:shopping_app/core/database/sqflite_helper.dart';
import 'package:shopping_app/features/account/data/models/profile_model.dart';
import 'package:sqflite/sqflite.dart';

class UserLocalDataSource {
  final SqfliteHelper dbHelper;

  UserLocalDataSource({SqfliteHelper? dbHelper})
      : dbHelper = dbHelper ?? SqfliteHelper.instance;

  Future<void> cacheProfile(ProfileModel profile) async {
    final db = await dbHelper.database;
    await db.insert(
      'user_profile',
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<ProfileModel?> getCachedProfile() async {
    final db = await dbHelper.database;
    final results = await db.query('user_profile', limit: 1);
    if (results.isNotEmpty) {
      return ProfileModel.fromMap(results.first);
    }
    return null;
  }
}

