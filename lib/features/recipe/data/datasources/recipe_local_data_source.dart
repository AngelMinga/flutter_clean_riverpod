import '../models/recipe_model.dart';

abstract class RecipeLocalDataSource {
  Future<void> cacheRecipe(RecipeModel model);
}
