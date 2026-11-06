import 'package:shopping_app/features/home/domain/entities/category_entity.dart';
import 'package:shopping_app/features/home/domain/entities/product_entity.dart';

abstract class HomeCategoryState {}

class HomeCategoryLoading extends HomeCategoryState {}

class HomeCategorySuccess extends HomeCategoryState {
  final List<CategoryEntity> categories;

  HomeCategorySuccess(this.categories);
}

class HomeCategoryError extends HomeCategoryState {
  final String message;

  HomeCategoryError(this.message);
}

abstract class HomeProductState {}

class HomeProductLoading extends HomeProductState {}

class HomeProductSuccess extends HomeProductState {
  final List<ProductEntity> products;

  HomeProductSuccess(this.products);
}

class HomeProductError extends HomeProductState {
  final String message;

  HomeProductError(this.message);
}

class HomeState {
  final HomeCategoryState categoryState;
  final HomeProductState productState;
  final String selectedCategory;
  final bool isLoadingMore;
  final bool hasMore;

  HomeState({
    required this.categoryState,
    required this.productState,
    this.selectedCategory = 'All',
    this.isLoadingMore = false,
    this.hasMore = true,
  });

  factory HomeState.initial() => HomeState(
        categoryState: HomeCategoryLoading(),
        productState: HomeProductLoading(),
      );

  HomeState copyWith({
    HomeCategoryState? categoryState,
    HomeProductState? productState,
    String? selectedCategory,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return HomeState(
      categoryState: categoryState ?? this.categoryState,
      productState: productState ?? this.productState,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
