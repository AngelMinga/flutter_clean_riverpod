#!/bin/bash

# Crear estructura core
mkdir -p lib/core/{error,network,storage,usecase,utils,constants}

# Core files
cat > lib/core/error/exceptions.dart << 'EOL'
abstract class AppException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  AppException(this.message, [this.stackTrace]);
}

class ServerException extends AppException {
  ServerException(String message, [StackTrace? stackTrace])
    : super(message, stackTrace);
}

class CacheException extends AppException {
  CacheException(String message, [StackTrace? stackTrace])
    : super(message, stackTrace);
}
EOL

cat > lib/core/network/api_client.dart << 'EOL'
import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio();

  Future<Response> get(String url) async {
    try {
      return await _dio.get(url);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }
}
EOL

cat > lib/core/storage/local_storage.dart << 'EOL'
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorage {
  Future<void> saveString(String key, String value);
  Future<String?> getString(String key);
}

class SharedPrefStorage implements LocalStorage {
  @override
  Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}
EOL

cat > lib/core/usecase/usecase.dart << 'EOL'
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

class NoParams {}
EOL

cat > lib/core/utils/date_formatter.dart << 'EOL'
class DateFormatter {
  static String format(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
EOL

cat > lib/core/constants/app_constants.dart << 'EOL'
class AppConstants {
  static const String apiBaseUrl = 'https://api.example.com';
  static const Duration connectTimeout = Duration(seconds: 30);
}
EOL

# Crear estructura features
mkdir -p lib/features/{user,recipe}

# User feature
mkdir -p lib/features/user/data/{models,datasources,repositories}
mkdir -p lib/features/user/domain/{entities,repositories,usecases}
mkdir -p lib/features/user/presentation/{providers,screens,widgets}

# User data layer
cat > lib/features/user/data/models/user_model.dart << 'EOL'
class UserModel {
  final String id;
  final String name;

  UserModel({required this.id, required this.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
EOL

cat > lib/features/user/data/datasources/user_remote_data_source.dart << 'EOL'
abstract class UserRemoteDataSource {
  Future<UserModel> getUser(String userId);
}
EOL

cat > lib/features/user/data/datasources/user_local_data_source.dart << 'EOL'
abstract class UserLocalDataSource {
  Future<void> cacheUser(UserModel user);
}
EOL

cat > lib/features/user/data/repositories/user_repository_impl.dart << 'EOL'
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';
import '../datasources/user_local_data_source.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> getUser(String userId) async {
    try {
      final userModel = await remoteDataSource.getUser(userId);
      await localDataSource.cacheUser(userModel);
      return userModel.toEntity();
    } catch (e) {
      throw Exception('Failed to get user');
    }
  }
}
EOL

# User domain layer
cat > lib/features/user/domain/entities/user.dart << 'EOL'
class User {
  final String id;
  final String name;

  User({required this.id, required this.name});
}
EOL

cat > lib/features/user/domain/repositories/user_repository.dart << 'EOL'
import '../entities/user.dart';

abstract class UserRepository {
  Future<User> getUser(String userId);
}
EOL

cat > lib/features/user/domain/usecases/get_user.dart << 'EOL'
import '../repositories/user_repository.dart';
import '../../core/usecase/usecase.dart';

class GetUser implements UseCase<User, String> {
  final UserRepository repository;

  GetUser(this.repository);

  @override
  Future<User> call(String userId) async {
    return await repository.getUser(userId);
  }
}
EOL

cat > lib/features/user/domain/usecases/save_user.dart << 'EOL'
import '../repositories/user_repository.dart';
import '../../core/usecase/usecase.dart';
import '../entities/user.dart';

class SaveUser implements UseCase<void, User> {
  final UserRepository repository;

  SaveUser(this.repository);

  @override
  Future<void> call(User user) async {
    await repository.saveUser(user);
  }
}
EOL

# User presentation layer
cat > lib/features/user/presentation/providers/user_provider.dart << 'EOL'
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/usecases/get_user.dart';

final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<User?>>((ref) {
  return UserNotifier(ref.read);
});

class UserNotifier extends StateNotifier<AsyncValue<User?>> {
  final Reader _read;

  UserNotifier(this._read) : super(const AsyncValue.data(null));

  Future<void> fetchUser(String userId) async {
    state = const AsyncValue.loading();
    try {
      final user = await _read(getUserProvider).call(userId);
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
EOL

cat > lib/features/user/presentation/screens/user_screen.dart << 'EOL'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';

class UserScreen extends ConsumerWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: userState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (user) => UserCard(user: user),
      ),
    );
  }
}
EOL

cat > lib/features/user/presentation/widgets/user_card.dart << 'EOL'
import 'package:flutter/material.dart';
import '../../../domain/entities/user.dart';

class UserCard extends StatelessWidget {
  final User? user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(user?.name ?? 'No user'),
        subtitle: Text(user?.id ?? ''),
      ),
    );
  }
}
EOL

# Recipe feature (similar structure)
mkdir -p lib/features/recipe/data/{models,datasources,repositories}
mkdir -p lib/features/recipe/domain/{entities,repositories,usecases}
mkdir -p lib/features/recipe/presentation/{providers,screens,widgets}

# Recipe data layer
cat > lib/features/recipe/data/models/recipe_model.dart << 'EOL'
class RecipeModel {
  final String id;
  final String title;

  RecipeModel({required this.id, required this.title});

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'],
      title: json['title'],
    );
  }
}
EOL

cat > lib/features/recipe/data/datasources/recipe_remote_data_source.dart << 'EOL'
abstract class RecipeRemoteDataSource {
  Future<RecipeModel> getRecipe(String recipeId);
}
EOL

cat > lib/features/recipe/data/datasources/recipe_local_data_source.dart << 'EOL'
abstract class RecipeLocalDataSource {
  Future<void> cacheRecipe(RecipeModel recipe);
}
EOL

cat > lib/features/recipe/data/repositories/recipe_repository_impl.dart << 'EOL'
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/recipe_remote_data_source.dart';
import '../datasources/recipe_local_data_source.dart';
import '../models/recipe_model.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;
  final RecipeLocalDataSource localDataSource;

  RecipeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Recipe> getRecipe(String recipeId) async {
    try {
      final recipeModel = await remoteDataSource.getRecipe(recipeId);
      await localDataSource.cacheRecipe(recipeModel);
      return recipeModel.toEntity();
    } catch (e) {
      throw Exception('Failed to get recipe');
    }
  }
}
EOL

# Recipe domain layer
cat > lib/features/recipe/domain/entities/recipe.dart << 'EOL'
class Recipe {
  final String id;
  final String title;

  Recipe({required this.id, required this.title});
}
EOL

cat > lib/features/recipe/domain/repositories/recipe_repository.dart << 'EOL'
import '../entities/recipe.dart';

abstract class RecipeRepository {
  Future<Recipe> getRecipe(String recipeId);
}
EOL

cat > lib/features/recipe/domain/usecases/get_recipe.dart << 'EOL'
import '../repositories/recipe_repository.dart';
import '../../core/usecase/usecase.dart';

class GetRecipe implements UseCase<Recipe, String> {
  final RecipeRepository repository;

  GetRecipe(this.repository);

  @override
  Future<Recipe> call(String recipeId) async {
    return await repository.getRecipe(recipeId);
  }
}
EOL

cat > lib/features/recipe/domain/usecases/save_recipe.dart << 'EOL'
import '../repositories/recipe_repository.dart';
import '../../core/usecase/usecase.dart';
import '../entities/recipe.dart';

class SaveRecipe implements UseCase<void, Recipe> {
  final RecipeRepository repository;

  SaveRecipe(this.repository);

  @override
  Future<void> call(Recipe recipe) async {
    await repository.saveRecipe(recipe);
  }
}
EOL

# Recipe presentation layer
cat > lib/features/recipe/presentation/providers/recipe_provider.dart << 'EOL'
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/usecases/get_recipe.dart';

final recipeProvider = StateNotifierProvider<RecipeNotifier, AsyncValue<Recipe?>>((ref) {
  return RecipeNotifier(ref.read);
});

class RecipeNotifier extends StateNotifier<AsyncValue<Recipe?>> {
  final Reader _read;

  RecipeNotifier(this._read) : super(const AsyncValue.data(null));

  Future<void> fetchRecipe(String recipeId) async {
    state = const AsyncValue.loading();
    try {
      final recipe = await _read(getRecipeProvider).call(recipeId);
      state = AsyncValue.data(recipe);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
EOL

cat > lib/features/recipe/presentation/screens/recipe_screen.dart << 'EOL'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recipe_provider.dart';

class RecipeScreen extends ConsumerWidget {
  const RecipeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeState = ref.watch(recipeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Details')),
      body: recipeState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (recipe) => RecipeCard(recipe: recipe),
      ),
    );
  }
}
EOL

cat > lib/features/recipe/presentation/widgets/recipe_card.dart << 'EOL'
import 'package:flutter/material.dart';
import '../../../domain/entities/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe? recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(recipe?.title ?? 'No recipe'),
        subtitle: Text(recipe?.id ?? ''),
      ),
    );
  }
}
EOL

# Main and routes
mkdir -p lib/routes

cat > lib/main.dart << 'EOL'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/recipe/presentation/screens/recipe_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Architecture Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RecipeScreen(),
    );
  }
}
EOL

cat > lib/routes/app_router.dart << 'EOL'
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const RecipeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
EOL

echo "✅ Estructura de proyecto generada exitosamente!"