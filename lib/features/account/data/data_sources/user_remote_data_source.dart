import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping_app/core/constants/api_constants.dart';
import 'package:shopping_app/core/local_storage/cache_helper.dart';
import 'package:shopping_app/features/account/data/models/profile_model.dart';

class UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSource({http.Client? client}) : client = client ?? http.Client();

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

  Future<ProfileModel> getUserData() async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.userData}');
    final response = await client.get(url, headers: _buildHeaders());

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      if (data is Map && data.containsKey('message') && data['message'] is Map) {
        return ProfileModel.fromJson(data['message'] as Map<String, dynamic>);
      }
      throw Exception('Unexpected profile data format');
    } else {
      throw Exception('Failed to load profile: ${response.statusCode}');
    }
  }

  Future<bool> editUserData({
    required String name,
    required String phone,
    required String address,
    String? image,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.editUserData}');
    final body = jsonEncode({
      'name': name,
      'phone': phone,
      'address': address,
      if (image != null && image.isNotEmpty) 'image': image,
    });

    final response = await client.post(url, headers: _buildHeaders(), body: body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    } else {
      throw Exception('Failed to update profile: ${response.statusCode} - ${response.body}');
    }
  }
}

