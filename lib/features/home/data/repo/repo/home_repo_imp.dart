import 'package:shopping_app/features/home/data/local/home_local_data_source.dart';
import 'package:shopping_app/features/home/data/models/category_model.dart';
import 'package:shopping_app/features/home/data/models/product_model.dart';
import 'package:shopping_app/features/home/data/repo/data_source/home_data_source_imp.dart';
import 'package:shopping_app/features/home/data/repo/data_source/home_data_source_interface.dart';
import 'package:shopping_app/features/home/data/repo/repo/home_repo_interface.dart';

class HomeRepoImp implements HomeRepoInterface {
  final HomeDataSourceInterface remoteDataSource;
  final HomeLocalDataSource localDataSource;

  HomeRepoImp({
    HomeDataSourceInterface? remoteDataSource,
    HomeLocalDataSource? localDataSource,
  })  : remoteDataSource = remoteDataSource ?? HomeDataSourceImp(),
        localDataSource = localDataSource ?? HomeLocalDataSource();

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final remoteCategories = await remoteDataSource.getAllCategories();
      if (remoteCategories.isNotEmpty) {
        await localDataSource.cacheCategories(remoteCategories);
      }
      return remoteCategories;
    } catch (_) {
      try {
        final localCategories = await localDataSource.getCachedCategories();
        if (localCategories.isNotEmpty) {
          return localCategories;
        }
      } catch (_) {}
      return [];
    }
  }

  @override
  Future<List<ProductModel>> getAllProducts({int skip = 0, int limit = 10}) async {
    try {
      final remoteProducts = await remoteDataSource.getAllProducts(skip: skip, limit: limit);
      if (remoteProducts.isNotEmpty) {
        await localDataSource.cacheProducts(remoteProducts);
      }
      return remoteProducts;
    } catch (_) {
      try {
        final localProducts = await localDataSource.getCachedProducts();
        return localProducts;
      } catch (_) {
        return [];
      }
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(
    String category, {
    int skip = 0,
    int limit = 10,
  }) async {
    try {
      final remoteProducts = await remoteDataSource.getProductsByCategory(
        category,
        skip: skip,
        limit: limit,
      );
      if (remoteProducts.isNotEmpty) {
        await localDataSource.cacheProducts(remoteProducts);
      }
      return remoteProducts;
    } catch (_) {
      try {
        return await localDataSource.getCachedProductsByCategory(category);
      } catch (_) {
        return [];
      }
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    try {
      final product = await remoteDataSource.getProductById(id);
      await localDataSource.cacheProducts([product]);
      return product;
    } catch (_) {
      final local = await localDataSource.getCachedProductById(id);
      if (local != null) return local;
      rethrow;
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(
    String query, {
    int skip = 0,
    int limit = 10,
  }) async {
    try {
      final remoteProducts = await remoteDataSource.searchProducts(query, skip: skip, limit: limit);
      if (remoteProducts.isNotEmpty) {
        await localDataSource.cacheProducts(remoteProducts);
      }
      return remoteProducts;
    } catch (_) {
      return await localDataSource.searchCachedProducts(query);
    }
  }

  @override
  Future<void> toggleFavorite(ProductModel product) async {
    product.isFavorite = !product.isFavorite;
    await localDataSource.toggleFavorite(product.id, product.isFavorite);
  }
}

typedef HomeRepository = HomeRepoImp;
