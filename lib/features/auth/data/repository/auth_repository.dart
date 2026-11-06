import 'package:shopping_app/features/auth/data/local/auth_local_data_source.dart';
import 'package:shopping_app/features/auth/data/models/login_request_model.dart';
import 'package:shopping_app/features/auth/data/models/register_request_model.dart';
import 'package:shopping_app/features/auth/data/models/user_model.dart';
import 'package:shopping_app/features/auth/data/remote/auth_remote_data_source.dart';

class AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepository({
    AuthRemoteDataSource? remoteDataSource,
    AuthLocalDataSource? localDataSource,
  })  : remoteDataSource = remoteDataSource ?? AuthRemoteDataSource(),
        localDataSource = localDataSource ?? AuthLocalDataSource();

  Future<UserModel> register(RegisterRequestModel request) async {
    final user = await remoteDataSource.register(request);

    await localDataSource.saveUser(user);

    return user;
  }

  Future<UserModel> login(LoginRequestModel request) async {
    final user = await remoteDataSource.login(request);

    await localDataSource.saveUser(user);

    return user;
  }

  Future<UserModel?> getSavedUser() async {
    return await localDataSource.getUser();
  }

  Future<void> logout() async {
    await localDataSource.clearUser();
  }
}
