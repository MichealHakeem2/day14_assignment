import 'package:shopping_app/features/home/data/models/category_model.dart';
import 'package:shopping_app/features/home/data/models/product_model.dart';

abstract class HomeDataSourceInterface {
  Future<List<CategoryModel>> getAllCategories();
  Future<List<ProductModel>> getAllProducts({int skip = 0, int limit = 10});
  Future<List<ProductModel>> getProductsByCategory(String category, {int skip = 0, int limit = 10});
  Future<ProductModel> getProductById(int id);
  Future<List<ProductModel>> searchProducts(String query, {int skip = 0, int limit = 10});
}

