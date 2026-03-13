import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/datasources/user_remote_data_source.dart';
import '../../data/datasources/user_local_data_source.dart';
import '../../domain/repositories/user_repository.dart';
import '../../data/models/user_model.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(
    remoteDataSource: FakeUserRemoteDataSource(),
    localDataSource: FakeUserLocalDataSource(),
  );
});

class FakeUserRemoteDataSource implements UserRemoteDataSource {
  @override
  Future<UserModel> getUser(String id) async {
    return UserModel(id: id, title: 'Fake User $id');
  }
}

class FakeUserLocalDataSource implements UserLocalDataSource {
  @override
  Future<void> cacheUser(UserModel model) async {}
}
