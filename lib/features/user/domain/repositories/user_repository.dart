import '../entities/user.dart';

abstract class UserRepository {
  Future<User> getUser(String id);
  Future<void> saveUser(User entity);
}
