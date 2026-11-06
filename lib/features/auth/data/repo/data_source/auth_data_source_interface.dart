import 'package:shopping_app/core/network/api_result.dart';
import 'package:shopping_app/features/auth/data/models/login_response_model.dart';
import 'package:shopping_app/features/auth/data/models/register_request_model.dart';

abstract class AuthDataSourceInterface {
  Future<ApiResult<LoginResponseModel>> login(String email, String password);
  Future<ApiResult<String>> register(RegisterRequestModel request);
}
