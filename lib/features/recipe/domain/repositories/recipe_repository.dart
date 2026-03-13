import '../entities/recipe.dart';

abstract class RecipeRepository {
  Future<Recipe> getRecipe(String id);
  Future<void> saveRecipe(Recipe entity);
}
