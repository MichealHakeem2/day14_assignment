import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/core/constants/api_constants.dart';
import 'package:shopping_app/core/local_storage/cache_helper.dart';
import 'package:shopping_app/features/cart/data/models/cart_item_model.dart';

class CartRemoteDataSource {
  final http.Client client;

  CartRemoteDataSource({http.Client? client}) : client = client ?? http.Client();

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

  Future<List<CartItemModel>> getCart() async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getCart}');
    final response = await client.get(url, headers: _buildHeaders());

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      if (data is Map && data.containsKey('list') && data['list'] is List) {
        final List<CartItemModel> list = [];
        for (var item in data['list']) {
          if (item is Map<String, dynamic>) {
            list.add(CartItemModel.fromJson(item));
          } else if (item is int) {
            list.add(CartItemModel(
              productId: item,
              title: 'Product $item',
              price: 0.0,
              image: '',
              quantity: 1,
            ));
          }
        }
        return list;
      }
      return [];
    } else {
      throw Exception('Failed to fetch cart: ${response.statusCode}');
    }
  }

  Future<bool> addToCart(int productId) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.addCart}');
    final body = jsonEncode({'productId': productId});

    try {
      final response = await client.post(url, headers: _buildHeaders(), body: body);
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      debugPrint('CartRemoteDataSource addToCart error: $e');
      return false;
    }
  }

  Future<bool> deleteFromCart(int productId) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.deleteCart}');
    final body = jsonEncode({'productId': productId});

    try {
      final request = http.Request('DELETE', url);
      request.headers.addAll(_buildHeaders());
      request.body = body;
      final streamedResponse = await client.send(request);
      return streamedResponse.statusCode >= 200 && streamedResponse.statusCode < 300;
    } catch (e) {
      debugPrint('CartRemoteDataSource deleteFromCart error: $e');
      return false;
    }
  }
}
