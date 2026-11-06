import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shopping_app/core/constants/app_colors.dart';
import 'package:shopping_app/features/cart/data/repository/cart_repository.dart';
import 'package:shopping_app/features/favorite/data/repository/favorite_repository.dart';
import 'package:shopping_app/features/home/data/models/product_model.dart';
import 'package:shopping_app/features/home/data/repository/home_repository.dart';
import 'package:shopping_app/features/home/presentation/product_details_screen.dart';
import 'package:shopping_app/features/home/presentation/widgets/product_card.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final HomeRepository _homeRepository = HomeRepository();
  final FavoriteRepository _favoriteRepository = FavoriteRepository.instance;
  final CartRepository _cartRepository = CartRepository.instance;

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  List<ProductModel> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _results = [];
        _hasSearched = false;
        _isLoading = false;
      });
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(trimmed);
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      final items = await _homeRepository.searchProducts(query, skip: 0, limit: 20);
      if (mounted) {
        for (var item in items) {
          item.isFavorite = await _favoriteRepository.isFavorite(item.id);
        }
        setState(() {
          _results = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onToggleFavorite(ProductModel product) async {
    final isFav = await _favoriteRepository.toggleFavorite(product);
    setState(() => product.isFavorite = isFav);
  }

  void _onAddToCart(ProductModel product) async {
    await _cartRepository.addToCart(product);
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.dark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search products...',
              hintStyle: const TextStyle(fontSize: 14, color: AppColors.grey),
              prefixIcon: const Icon(Icons.search, color: AppColors.grey, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.grey, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (!_hasSearched) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: AppColors.grey),
            SizedBox(height: 12),
            Text(
              'Type to search products',
              style: TextStyle(color: AppColors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.grey.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search_off, size: 48, color: AppColors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              'No products found for "${_searchController.text}"',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try searching with a different keyword',
              style: TextStyle(color: AppColors.grey, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _results.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 14,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final product = _results[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(productId: product.id),
              ),
            );
          },
          child: ProductCard(
            product: product.toEntity(),
            onFavoriteTap: () => _onToggleFavorite(product),
            onAddToCart: () => _onAddToCart(product),
          ),
        );
      },
    );
  }
}

