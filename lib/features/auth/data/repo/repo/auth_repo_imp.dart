import 'package:shopping_app/core/network/api_result.dart';
import 'package:shopping_app/features/auth/data/models/login_response_model.dart';
import 'package:shopping_app/features/auth/data/models/register_request_model.dart';
import 'package:shopping_app/features/auth/data/repo/data_source/auth_data_source_imp.dart';
import 'package:shopping_app/features/auth/data/repo/data_source/auth_data_source_interface.dart';
import 'package:shopping_app/features/auth/data/repo/repo/auth_repo_interface.dart';

class AuthRepoImp implements AuthRepoInterface {
  final AuthDataSourceInterface remoteDataSource;
  final AuthDataSourceInterface localDataSource;

  AuthRepoImp({
    AuthDataSourceInterface? remoteDataSource,
    AuthDataSourceInterface? localDataSource,
  })  : remoteDataSource = remoteDataSource ?? AuthDataSourceImp(),
        localDataSource = localDataSource ?? AuthDataSourceLocalImp();

  @override
  Future<ApiResult<LoginResponseModel>> login(String email, String password) async {
    return await remoteDataSource.login(email, password);
  }

  @override
  Future<ApiResult<String>> register(RegisterRequestModel request) async {
    return await remoteDataSource.register(request);
  }
}
