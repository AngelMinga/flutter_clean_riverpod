import '../../../../core/usecase/usecase.dart';
import '../repositories/recipe_repository.dart';
import '../entities/recipe.dart';

class SaveRecipe implements UseCase<void, Recipe> {
  final RecipeRepository repository;

  SaveRecipe(this.repository);

  @override
  Future<void> call(Recipe entity) => repository.saveRecipe(entity);
}
