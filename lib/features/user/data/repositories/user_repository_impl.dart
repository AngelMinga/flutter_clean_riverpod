import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';
import '../datasources/user_local_data_source.dart';
import '../models/user_model.dart';
import '../../domain/entities/user.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> getUser(String id) async {
    final model = await remoteDataSource.getUser(id);
    await localDataSource.cacheUser(model);
    return model.toEntity();
  }

  @override
  Future<void> saveUser(User entity) async {
    final model = UserModel(id: entity.id, title: entity.title);
    await localDataSource.cacheUser(model);
  }
}
