import 'package:shopping_app/core/local_storage/cache_helper.dart';
import 'package:shopping_app/features/account/data/data_sources/user_local_data_source.dart';
import 'package:shopping_app/features/account/data/data_sources/user_remote_data_source.dart';
import 'package:shopping_app/features/account/data/models/profile_model.dart';

class UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  UserRepository({
    UserRemoteDataSource? remoteDataSource,
    UserLocalDataSource? localDataSource,
  })  : remoteDataSource = remoteDataSource ?? UserRemoteDataSource(),
        localDataSource = localDataSource ?? UserLocalDataSource();

  Future<ProfileModel> getUserData() async {
    try {
      final remoteProfile = await remoteDataSource.getUserData();
      await localDataSource.cacheProfile(remoteProfile);
      return remoteProfile;
    } catch (_) {
      final cached = await localDataSource.getCachedProfile();
      if (cached != null) {
        return cached;
      }
      return ProfileModel(
        id: '1',
        name: CacheHelper.userName ?? '',
        email: CacheHelper.userEmail ?? '',
        phone: '',
        address: '',
        image: '',
      );
    }
  }

  Future<bool> editUserData({
    required String name,
    required String phone,
    required String address,
    String? image,
  }) async {
    final cached = await localDataSource.getCachedProfile();
    final updated = ProfileModel(
      id: cached?.id ?? '1',
      name: name,
      email: cached?.email ?? CacheHelper.userEmail ?? '',
      phone: phone,
      address: address,
      image: image ?? cached?.image ?? '',
    );
    await localDataSource.cacheProfile(updated);

    try {
      final success = await remoteDataSource.editUserData(
        name: name,
        phone: phone,
        address: address,
        image: image,
      );
      return success;
    } catch (_) {
      return true;
    }
  }
}
