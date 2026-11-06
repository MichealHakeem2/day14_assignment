import 'package:shopping_app/core/network/api_result.dart';
import 'package:shopping_app/features/home/domain/entities/category_entity.dart';
import 'package:shopping_app/features/home/domain/entities/product_entity.dart';

abstract class HomeRepository {
  Future<ApiResult<List<CategoryEntity>>> getAllCategories();
  Future<ApiResult<List<ProductEntity>>> getAllProducts({int skip = 0, int limit = 10});
}
