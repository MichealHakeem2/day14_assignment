import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping_app/core/constants/api_constants.dart';
import 'package:shopping_app/features/auth/data/models/login_request_model.dart';
import 'package:shopping_app/features/auth/data/models/register_request_model.dart';
import 'package:shopping_app/features/auth/data/models/user_model.dart';

class AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSource({http.Client? client}) : client = client ?? http.Client();

  Future<UserModel> register(RegisterRequestModel request) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}');

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return UserModel(
        name: request.name,
        email: request.email,
        phone: request.phone,
        token: data['token'],
      );
    } else {
      throw Exception(data['message'] ?? 'Failed to register');
    }
  }

  Future<UserModel> login(LoginRequestModel request) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}');

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final userJson = data['user'] ?? {};
      return UserModel(
        name: userJson['name'] ?? '',
        email: request.email,
        phone: userJson['phone'] ?? '',
        token: data['token'],
      );
    } else {
      throw Exception(data['message'] ?? 'Failed to login');
    }
  }
}
