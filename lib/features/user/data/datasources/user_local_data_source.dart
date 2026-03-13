import '../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<void> cacheUser(UserModel model);
}
