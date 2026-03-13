import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/entities/user.dart';

final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<User?>>((ref) {
  return UserNotifier(ref);
});

class UserNotifier extends StateNotifier<AsyncValue<User?>> {
  final Ref ref;

  UserNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> fetchUser(String id) async {
    state = const AsyncValue.loading();
    try {
      final item = await ref.read(getUserProvider).call(id);
      state = AsyncValue.data(item);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
