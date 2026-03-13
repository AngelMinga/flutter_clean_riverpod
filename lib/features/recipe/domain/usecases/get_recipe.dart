import '../../../../core/usecase/usecase.dart';
import '../repositories/recipe_repository.dart';
import '../entities/recipe.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/recipe_repository_provider.dart';

final getRecipeProvider = Provider((ref) => GetRecipe(ref.watch(recipeRepositoryProvider)));

class GetRecipe implements UseCase<Recipe, String> {
  final RecipeRepository repository;

  GetRecipe(this.repository);

  @override
  Future<Recipe> call(String id) => repository.getRecipe(id);
}
