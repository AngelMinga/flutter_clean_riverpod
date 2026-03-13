import '../models/recipe_model.dart';

abstract class RecipeRemoteDataSource {
  Future<RecipeModel> getRecipe(String id);
}
