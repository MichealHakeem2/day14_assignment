import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/network/api_result.dart';
import 'package:shopping_app/features/favorite/data/repository/favorite_repository.dart';
import 'package:shopping_app/features/home/data/models/product_model.dart';
import 'package:shopping_app/features/home/domain/entities/category_entity.dart';
import 'package:shopping_app/features/home/domain/entities/product_entity.dart';
import 'package:shopping_app/features/home/domain/use_cases/get_all_categories_use_case.dart';
import 'package:shopping_app/features/home/domain/use_cases/get_all_products_use_case.dart';
import 'package:shopping_app/features/home/presentation/view_model/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetAllCategoriesUseCase getAllCategoriesUseCase;
  final GetAllProductsUseCase getAllProductsUseCase;
  final FavoriteRepository _favoriteRepository = FavoriteRepository.instance;

  int _skip = 0;
  final int _limit = 10;
  final List<ProductEntity> _currentProducts = [];

  HomeCubit({
    required this.getAllCategoriesUseCase,
    required this.getAllProductsUseCase,
  }) : super(HomeState.initial());

  Future<void> getAllCategories() async {
    emit(state.copyWith(categoryState: HomeCategoryLoading()));

    final result = await getAllCategoriesUseCase.call();
    if (result is Success<List<CategoryEntity>>) {
      emit(state.copyWith(categoryState: HomeCategorySuccess(result.data)));
    } else if (result is Failure<List<CategoryEntity>>) {
      emit(state.copyWith(categoryState: HomeCategoryError(result.message)));
    }
  }

  Future<void> getAllProducts({bool reset = false}) async {
    if (reset) {
      _skip = 0;
      _currentProducts.clear();
      emit(state.copyWith(
        productState: HomeProductLoading(),
        hasMore: true,
      ));
    }

    final result = await getAllProductsUseCase.call(skip: _skip, limit: _limit);

    if (result is Success<List<ProductEntity>>) {
      final items = result.data;
      for (var p in items) {
        try {
          p.isFavorite = await _favoriteRepository.isFavorite(p.id);
        } catch (_) {}
      }

      _currentProducts.addAll(items);
      final hasMoreItems = items.length >= _limit;

      emit(state.copyWith(
        productState: HomeProductSuccess(List.from(_currentProducts)),
        hasMore: hasMoreItems,
      ));
    } else if (result is Failure<List<ProductEntity>>) {
      emit(state.copyWith(productState: HomeProductError(result.message)));
    }
  }

  void selectCategory(String category) {
    if (state.selectedCategory == category) return;
    emit(state.copyWith(selectedCategory: category));
    getAllProducts(reset: true);
  }

  Future<void> loadMoreProducts() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));
    _skip += _limit;

    final result = await getAllProductsUseCase.call(skip: _skip, limit: _limit);

    if (result is Success<List<ProductEntity>>) {
      final items = result.data;
      for (var p in items) {
        try {
          p.isFavorite = await _favoriteRepository.isFavorite(p.id);
        } catch (_) {}
      }

      _currentProducts.addAll(items);
      final hasMoreItems = items.length >= _limit;

      emit(state.copyWith(
        productState: HomeProductSuccess(List.from(_currentProducts)),
        isLoadingMore: false,
        hasMore: hasMoreItems,
      ));
    } else if (result is Failure<List<ProductEntity>>) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  void toggleFavorite(ProductEntity product) async {
    // we need a ProductModel to pass to the old favorite repo
    final tempModel = ProductModel(
      id: product.id,
      title: product.title,
      price: product.price,
      image: product.image,
      images: product.images,
      discountPercentage: product.discountPercentage,
      rating: product.rating,
      stock: product.stock,
      isFavorite: product.isFavorite,
    );
    final isFav = await _favoriteRepository.toggleFavorite(tempModel);
    product.isFavorite = isFav;
    emit(state.copyWith(
      productState: HomeProductSuccess(List.from(_currentProducts)),
    ));
  }
}
