import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/core/constants/api_constants.dart';
import 'package:shopping_app/core/local_storage/cache_helper.dart';
import 'package:shopping_app/features/home/data/models/category_model.dart';
import 'package:shopping_app/features/home/data/models/product_model.dart';

class ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSource({http.Client? client}) : client = client ?? http.Client();

  Map<String, String> _buildHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    final token = CacheHelper.getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<List<ProductModel>> getProducts({
    int skip = 0,
    int limit = 10,
    String sortBy = 'title',
    String order = 'asc',
  }) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.products}?skip=$skip&limit=$limit&sortBy=$sortBy&order=$order',
    );
    final response = await client.get(url, headers: _buildHeaders());

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      if (data is Map && data.containsKey('list') && data['list'] is List) {
        return (data['list'] as List)
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (data is List) {
        return data
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } else {
      throw Exception('Failed to load products: ${response.statusCode} - ${response.body}');
    }
  }

  Future<ProductModel> getProductById(int id) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.products}/$id');
    final response = await client.get(url, headers: _buildHeaders());

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic>) {
        return ProductModel.fromJson(data);
      }
      throw Exception('Invalid product response format');
    } else {
      throw Exception('Failed to load product details: ${response.statusCode}');
    }
  }

  Future<List<CategoryModel>> getCategoryNames() async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.categoriesNames}');
    final response = await client.get(url, headers: _buildHeaders());

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      if (data is Map && data.containsKey('list') && data['list'] is List) {
        return (data['list'] as List)
            .map((item) => CategoryModel.fromJson(item))
            .toList();
      }
      return [];
    } else {
      debugPrint('Failed to load category names: ${response.statusCode}');
      return [];
    }
  }

  Future<List<ProductModel>> getProductsByCategory(
    String categoryName, {
    int skip = 0,
    int limit = 10,
  }) async {
    final encodedCat = Uri.encodeComponent(categoryName);
    final url = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.productCategory}/$encodedCat?skip=$skip&limit=$limit',
    );
    final response = await client.get(url, headers: _buildHeaders());

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      if (data is Map && data.containsKey('list') && data['list'] is List) {
        return (data['list'] as List)
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } else {
      throw Exception('Failed to load category products: ${response.statusCode}');
    }
  }

  Future<List<ProductModel>> filterProducts(
    String query, {
    int skip = 0,
    int limit = 10,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productsFilter}');
    final body = jsonEncode({
      'search': query,
      'skip': skip,
      'limit': limit,
    });
    final response = await client.post(url, headers: _buildHeaders(), body: body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      if (data is Map && data.containsKey('list') && data['list'] is List) {
        return (data['list'] as List)
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } else {
      throw Exception('Failed to search products: ${response.statusCode}');
    }
  }
}

