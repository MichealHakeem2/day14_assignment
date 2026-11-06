import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shopping_app/core/constants/api_constants.dart';
import 'package:shopping_app/core/network/api_result.dart';
import 'package:shopping_app/features/auth/data/models/login_response_model.dart';
import 'package:shopping_app/features/auth/data/models/register_request_model.dart';

abstract class AuthApi {
  static Future<ApiResult<String>> register(
    RegisterRequestModel request,
  ) async {
    try {
      Uri url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.register}");
      var response = await http.post(
        url,
        body: jsonEncode(request.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      log("statusCode ${response.statusCode}");
      log("body ${response.body}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var json = jsonDecode(response.body);
        return Success(json["message"]?.toString() ?? "Success");
      } else {
        try {
          var json = jsonDecode(response.body);
          return Failure(json["message"]?.toString() ?? json["error"]?.toString() ?? "Registration failed");
        } catch (_) {
          return Failure("Registration failed: ${response.statusCode}");
        }
      }
    } catch (e) {
      return Failure(e.toString());
    }
  }

  static Future<ApiResult<LoginResponseModel>> login(
    String email,
    String password,
  ) async {
    try {
      Uri url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.login}");
      var response = await http.post(
        url,
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      log("statusCode ${response.statusCode}");
      log("body ${response.body}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var json = jsonDecode(response.body);
        return Success(LoginResponseModel.fromJson(json));
      } else {
        try {
          var json = jsonDecode(response.body);
          return Failure(json["message"]?.toString() ?? json["error"]?.toString() ?? "Login failed");
        } catch (_) {
          return Failure("Login failed: ${response.statusCode}");
        }
      }
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
