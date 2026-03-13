import '../../../../core/usecase/usecase.dart';
import '../repositories/user_repository.dart';
import '../entities/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/user_repository_provider.dart';

final getUserProvider = Provider((ref) => GetUser(ref.watch(userRepositoryProvider)));

class GetUser implements UseCase<User, String> {
  final UserRepository repository;

  GetUser(this.repository);

  @override
  Future<User> call(String id) => repository.getUser(id);
}
