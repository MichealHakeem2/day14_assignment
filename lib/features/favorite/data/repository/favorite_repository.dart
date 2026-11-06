import 'package:flutter/foundation.dart';
import 'package:shopping_app/features/favorite/data/local/favorite_local_data_source.dart';
import 'package:shopping_app/features/favorite/data/remote/favorite_remote_data_source.dart';
import 'package:shopping_app/features/home/data/models/product_model.dart';

class FavoriteRepository {
  static final FavoriteRepository instance = FavoriteRepository._internal();
  factory FavoriteRepository() => instance;
  FavoriteRepository._internal();

  final FavoriteRemoteDataSource remoteDataSource = FavoriteRemoteDataSource();
  final FavoriteLocalDataSource localDataSource = FavoriteLocalDataSource();

  final ValueNotifier<List<int>> favoriteIdsNotifier = ValueNotifier<List<int>>([]);

  Future<void> refreshFavoriteIds() async {
    try {
      final items = await localDataSource.getFavorites();
      favoriteIdsNotifier.value = items.map((e) => e.id).toList();
    } catch (_) {}
  }

  Future<List<ProductModel>> getFavorites() async {
    try {
      final remoteList = await remoteDataSource.getFavorites();
      if (remoteList.isNotEmpty) {
        for (var p in remoteList) {
          await localDataSource.addFavorite(p);
        }
      }
    } catch (e) {
      debugPrint('FavoriteRepository getFavorites error: $e');
    }

    final localList = await localDataSource.getFavorites();
    await refreshFavoriteIds();
    return localList;
  }

  Future<bool> isFavorite(int productId) async {
    return await localDataSource.isFavorite(productId);
  }

  Future<bool> toggleFavorite(ProductModel product) async {
    final currentlyFav = await localDataSource.isFavorite(product.id);
    if (currentlyFav) {
      await localDataSource.deleteFavorite(product.id);
      product.isFavorite = false;
      await refreshFavoriteIds();
      try {
        await remoteDataSource.deleteFavorite(product.id);
      } catch (e) {
        debugPrint('FavoriteRepository deleteFavorite error: $e');
      }
      return false;
    } else {
      await localDataSource.addFavorite(product);
      product.isFavorite = true;
      await refreshFavoriteIds();
      try {
        await remoteDataSource.addFavorite(product.id);
      } catch (e) {
        debugPrint('FavoriteRepository addFavorite error: $e');
      }
      return true;
    }
  }
}
