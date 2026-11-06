import 'package:shopping_app/core/network/api_result.dart';
import 'package:shopping_app/features/home/domain/entities/category_entity.dart';
import 'package:shopping_app/features/home/domain/repository/home_repository.dart';

class GetAllCategoriesUseCase {
  final HomeRepository repository;

  GetAllCategoriesUseCase(this.repository);

  Future<ApiResult<List<CategoryEntity>>> call() {
    return repository.getAllCategories();
  }
}
