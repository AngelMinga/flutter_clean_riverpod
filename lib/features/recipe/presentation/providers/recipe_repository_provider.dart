import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/recipe_repository_impl.dart';
import '../../data/datasources/recipe_remote_data_source.dart';
import '../../data/datasources/recipe_local_data_source.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../../data/models/recipe_model.dart';

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  return RecipeRepositoryImpl(
    remoteDataSource: FakeRecipeRemoteDataSource(),
    localDataSource: FakeRecipeLocalDataSource(),
  );
});

class FakeRecipeRemoteDataSource implements RecipeRemoteDataSource {
  @override
  Future<RecipeModel> getRecipe(String id) async {
    return RecipeModel(id: id, title: 'Fake Recipe $id');
  }
}

class FakeRecipeLocalDataSource implements RecipeLocalDataSource {
  @override
  Future<void> cacheRecipe(RecipeModel model) async {}
}
