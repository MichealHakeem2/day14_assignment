import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping_app/core/constants/api_constants.dart';
import 'package:shopping_app/core/local_storage/cache_helper.dart';
import 'package:shopping_app/features/home/data/data_source/home_data_source.dart';
import 'package:shopping_app/features/home/data/models/category_dto.dart';
import 'package:shopping_app/features/home/data/models/product_dto.dart';

class HomeDataSourceImplementation implements HomeDataSource {
  final http.Client client;

  HomeDataSourceImplementation({http.Client? client})
      : client = client ?? http.Client();

  Map<String, String> _getHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    final token = CacheHelper.getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  @override
  Future<List<CategoryDto>> getAllCategories() async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.categories}');
    final response = await client.get(url, headers: _getHeaders());

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      if (data is Map && data.containsKey('list') && data['list'] is List) {
        return (data['list'] as List)
            .map((item) => CategoryDto.fromJson(item))
            .toList();
      } else if (data is List) {
        return data.map((item) => CategoryDto.fromJson(item)).toList();
      }
      return [];
    } else {
      // fallback to category names endpoint
      final fallbackUrl =
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.categoriesNames}');
      final fallbackResponse =
          await client.get(fallbackUrl, headers: _getHeaders());
      if (fallbackResponse.statusCode >= 200 &&
          fallbackResponse.statusCode < 300) {
        final data = jsonDecode(fallbackResponse.body);
        if (data is Map && data.containsKey('list') && data['list'] is List) {
          return (data['list'] as List)
              .map((item) => CategoryDto.fromJson(item))
              .toList();
        } else if (data is List) {
          return data.map((item) => CategoryDto.fromJson(item)).toList();
        }
      }
      throw Exception('Failed to load categories');
    }
  }

  @override
  Future<List<ProductDto>> getAllProducts({int skip = 0, int limit = 10}) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.products}?skip=$skip&limit=$limit&sortBy=title&order=asc',
    );
    final response = await client.get(url, headers: _getHeaders());

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      if (data is Map && data.containsKey('list') && data['list'] is List) {
        return (data['list'] as List)
            .map((item) => ProductDto.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (data is Map && data.containsKey('products') && data['products'] is List) {
        return (data['products'] as List)
            .map((item) => ProductDto.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (data is List) {
        return data
            .map((item) => ProductDto.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } else {
      throw Exception('Failed to load products');
    }
  }
}

