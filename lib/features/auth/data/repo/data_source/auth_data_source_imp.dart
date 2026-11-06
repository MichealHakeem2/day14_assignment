import 'package:shopping_app/core/network/api_result.dart';
import 'package:shopping_app/features/auth/data/api/auth_api.dart';
import 'package:shopping_app/features/auth/data/models/login_response_model.dart';
import 'package:shopping_app/features/auth/data/models/register_request_model.dart';
import 'package:shopping_app/features/auth/data/repo/data_source/auth_data_source_interface.dart';

class AuthDataSourceImp implements AuthDataSourceInterface {
  @override
  Future<ApiResult<LoginResponseModel>> login(
    String email,
    String password,
  ) async =>
      await AuthApi.login(email, password);

  @override
  Future<ApiResult<String>> register(RegisterRequestModel request) async =>
      await AuthApi.register(request);
}

class AuthDataSourceLocalImp implements AuthDataSourceInterface {
  @override
  Future<ApiResult<LoginResponseModel>> login(String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<String>> register(RegisterRequestModel request) {
    throw UnimplementedError();
  }
}
