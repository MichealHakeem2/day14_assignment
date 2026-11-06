import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/constants/app_colors.dart';
import 'package:shopping_app/core/local_storage/cache_helper.dart';
import 'package:shopping_app/core/routes/app_routes.dart';
import 'package:shopping_app/features/cart/data/repository/cart_repository.dart';
import 'package:shopping_app/features/home/data/models/product_model.dart';
import 'package:shopping_app/features/home/data/repository/home_repository_implementation.dart';
import 'package:shopping_app/features/home/domain/entities/category_entity.dart';
import 'package:shopping_app/features/home/domain/entities/product_entity.dart';
import 'package:shopping_app/features/home/domain/use_cases/get_all_categories_use_case.dart';
import 'package:shopping_app/features/home/domain/use_cases/get_all_products_use_case.dart';
import 'package:shopping_app/features/home/presentation/product_details_screen.dart';
import 'package:shopping_app/features/home/presentation/view_model/home_cubit.dart';
import 'package:shopping_app/features/home/presentation/view_model/home_state.dart';
import 'package:shopping_app/features/home/presentation/widgets/banner_widget.dart';
import 'package:shopping_app/features/home/presentation/widgets/category_item.dart';
import 'package:shopping_app/features/home/presentation/widgets/product_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // create repository and use cases here (dependency injection)
    final homeRepository = HomeRepositoryImplementation();
    final getAllCategoriesUseCase = GetAllCategoriesUseCase(homeRepository);
    final getAllProductsUseCase = GetAllProductsUseCase(homeRepository);

    return BlocProvider(
      create: (context) => HomeCubit(
        getAllCategoriesUseCase: getAllCategoriesUseCase,
        getAllProductsUseCase: getAllProductsUseCase,
      )..getAllCategories()..getAllProducts(),
      child: const _HomeScreenBody(),
    );
  }
}

class _HomeScreenBody extends StatefulWidget {
  const _HomeScreenBody();

  @override
  State<_HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<_HomeScreenBody> {
  final ScrollController _scrollController = ScrollController();
  final CartRepository _cartRepository = CartRepository.instance;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<HomeCubit>().loadMoreProducts();
    }
  }

  void _onAddToCart(ProductEntity product) async {
    // CartRepository still uses ProductModel so we convert here
    final productModel = ProductModel(
      id: product.id,
      title: product.title,
      price: product.price,
      image: product.image,
      images: product.images,
      discountPercentage: product.discountPercentage,
      rating: product.rating,
      stock: product.stock,
    );
    await _cartRepository.addToCart(productModel);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added "${product.title}" to cart'),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayName = CacheHelper.userName ?? '';
    final cubit = context.read<HomeCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              cubit.getAllCategories(),
              cubit.getAllProducts(reset: true),
            ]);
          },
          color: AppColors.primary,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayName.isNotEmpty ? 'Hi $displayName !' : 'Hi !',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                "Let's Start Your Day",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.dark,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.notifications_none_rounded, color: AppColors.dark),
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.notifications);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.productSearch);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.grey.withValues(alpha: 0.2)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.search, color: AppColors.grey, size: 22),
                              SizedBox(width: 10),
                              Text(
                                'Search products...',
                                style: TextStyle(color: AppColors.grey, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      const BannerWidget(),
                      const SizedBox(height: 20),

                      const Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.dark,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildCategoriesSection(),
                      const SizedBox(height: 20),

                      BlocBuilder<HomeCubit, HomeState>(
                        buildWhen: (prev, curr) =>
                            prev.productState != curr.productState ||
                            prev.selectedCategory != curr.selectedCategory,
                        builder: (context, state) {
                          int count = 0;
                          if (state.productState is HomeProductSuccess) {
                            count = (state.productState as HomeProductSuccess).products.length;
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                state.selectedCategory == 'All'
                                    ? 'Popular Products'
                                    : state.selectedCategory,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.dark,
                                ),
                              ),
                              Text(
                                '$count items',
                                style: const TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              _buildProductsGrid(cubit),

              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, curr) =>
          prev.categoryState != curr.categoryState ||
          prev.selectedCategory != curr.selectedCategory,
      builder: (context, state) {
        if (state.categoryState is HomeCategoryLoading) {
          return const SizedBox(
            height: 38,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
              ),
            ),
          );
        }

        if (state.categoryState is HomeCategoryError) {
          return SizedBox(
            height: 38,
            child: Center(
              child: Text(
                'Failed to load categories',
                style: TextStyle(color: Colors.red.shade400, fontSize: 12),
              ),
            ),
          );
        }

        List<CategoryEntity> categories = [];
        if (state.categoryState is HomeCategorySuccess) {
          categories = (state.categoryState as HomeCategorySuccess).categories;
        }

        final allCategories = [
          CategoryEntity(name: 'All', slug: 'all'),
          ...categories,
        ];

        return SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: allCategories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = allCategories[index];
              final isSelected =
                  state.selectedCategory.toLowerCase() == cat.name.toLowerCase();

              return CategoryItem(
                category: cat,
                isSelected: isSelected,
                onTap: () {
                  context.read<HomeCubit>().selectCategory(cat.name);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProductsGrid(HomeCubit cubit) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, curr) =>
          prev.productState != curr.productState ||
          prev.isLoadingMore != curr.isLoadingMore,
      builder: (context, state) {
        if (state.productState is HomeProductLoading) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (state.productState is HomeProductError) {
          final errorMsg = (state.productState as HomeProductError).message;
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(
                    errorMsg,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.grey),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => cubit.getAllProducts(reset: true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }

        final products = (state.productState as HomeProductSuccess).products;

        if (products.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox_outlined, size: 48, color: AppColors.grey),
                  const SizedBox(height: 12),
                  Text(
                    'No products found in ${state.selectedCategory}',
                    style: const TextStyle(color: AppColors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        return SliverMainAxisGroup(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.72,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = products[index];
                    return ProductItem(
                      product: product,
                      onFavoriteTap: () => cubit.toggleFavorite(product),
                      onAddToCart: () => _onAddToCart(product),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailsScreen(productId: product.id),
                          ),
                        ).then((_) {
                          cubit.getAllProducts();
                        });
                      },
                    );
                  },
                  childCount: products.length,
                ),
              ),
            ),

            if (state.isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
