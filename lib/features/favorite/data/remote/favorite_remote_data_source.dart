import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/core/constants/api_constants.dart';
import 'package:shopping_app/core/local_storage/cache_helper.dart';
import 'package:shopping_app/features/home/data/models/product_model.dart';

class FavoriteRemoteDataSource {
  final http.Client client;

  FavoriteRemoteDataSource({http.Client? client}) : client = client ?? http.Client();

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

  Future<List<ProductModel>> getFavorites() async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getFavorite}');
    final response = await client.get(url, headers: _buildHeaders());

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      if (data is Map && data.containsKey('list') && data['list'] is List) {
        final List<ProductModel> list = [];
        for (var item in data['list']) {
          if (item is Map<String, dynamic>) {
            final p = ProductModel.fromJson(item);
            p.isFavorite = true;
            list.add(p);
          } else if (item is int) {
            list.add(ProductModel(id: item, title: 'Product $item', price: 0.0, image: '', isFavorite: true));
          }
        }
        return list;
      }
      return [];
    } else {
      throw Exception('Failed to fetch favorites: ${response.statusCode}');
    }
  }

  Future<bool> addFavorite(int productId) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.addFavorite}');
    final body = jsonEncode({'productId': productId});

    try {
      final response = await client.post(url, headers: _buildHeaders(), body: body);
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      debugPrint('FavoriteRemoteDataSource addFavorite error: $e');
      return false;
    }
  }

  Future<bool> deleteFavorite(int productId) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.deleteFavorite}');
    final body = jsonEncode({'productId': productId});

    try {
      final request = http.Request('DELETE', url);
      request.headers.addAll(_buildHeaders());
      request.body = body;
      final streamedResponse = await client.send(request);
      return streamedResponse.statusCode >= 200 && streamedResponse.statusCode < 300;
    } catch (e) {
      debugPrint('FavoriteRemoteDataSource deleteFavorite error: $e');
      return false;
    }
  }
}
