import '../../../../core/usecase/usecase.dart';
import '../repositories/user_repository.dart';
import '../entities/user.dart';

class SaveUser implements UseCase<void, User> {
  final UserRepository repository;

  SaveUser(this.repository);

  @override
  Future<void> call(User entity) => repository.saveUser(entity);
}
