import '../../domain/repositories/recipe_repository.dart';
import '../datasources/recipe_remote_data_source.dart';
import '../datasources/recipe_local_data_source.dart';
import '../models/recipe_model.dart';
import '../../domain/entities/recipe.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;
  final RecipeLocalDataSource localDataSource;

  RecipeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Recipe> getRecipe(String id) async {
    final model = await remoteDataSource.getRecipe(id);
    await localDataSource.cacheRecipe(model);
    return model.toEntity();
  }

  @override
  Future<void> saveRecipe(Recipe entity) async {
    final model = RecipeModel(id: entity.id, title: entity.title);
    await localDataSource.cacheRecipe(model);
  }
}
