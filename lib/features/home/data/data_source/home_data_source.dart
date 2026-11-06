import 'package:shopping_app/features/home/data/models/category_dto.dart';
import 'package:shopping_app/features/home/data/models/product_dto.dart';

abstract class HomeDataSource {
  Future<List<CategoryDto>> getAllCategories();
  Future<List<ProductDto>> getAllProducts({int skip = 0, int limit = 10});
}

