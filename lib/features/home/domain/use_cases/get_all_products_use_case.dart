import 'package:shopping_app/core/network/api_result.dart';
import 'package:shopping_app/features/home/domain/entities/product_entity.dart';
import 'package:shopping_app/features/home/domain/repository/home_repository.dart';

class GetAllProductsUseCase {
  final HomeRepository repository;

  GetAllProductsUseCase(this.repository);

  Future<ApiResult<List<ProductEntity>>> call({int skip = 0, int limit = 10}) {
    return repository.getAllProducts(skip: skip, limit: limit);
  }
}
