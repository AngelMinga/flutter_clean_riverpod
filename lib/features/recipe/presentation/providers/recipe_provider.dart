import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_recipe.dart';
import '../../domain/entities/recipe.dart';

final recipeProvider = StateNotifierProvider<RecipeNotifier, AsyncValue<Recipe?>>((ref) {
  return RecipeNotifier(ref);
});

class RecipeNotifier extends StateNotifier<AsyncValue<Recipe?>> {
  final Ref ref;

  RecipeNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> fetchRecipe(String id) async {
    state = const AsyncValue.loading();
    try {
      final item = await ref.read(getRecipeProvider).call(id);
      state = AsyncValue.data(item);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
