#!/bin/bash

# Crear estructura de directorios
mkdir -p lib/data/datasources/local
mkdir -p lib/data/datasources/remote
mkdir -p lib/data/models
mkdir -p lib/data/repositories

mkdir -p lib/domain/entities
mkdir -p lib/domain/repositories
mkdir -p lib/domain/usecases

mkdir -p lib/presentation/providers
mkdir -p lib/presentation/screens
mkdir -p lib/presentation/widgets

# Crear archivos base con contenido inicial
# Data Layer
## Local DataSources
cat > lib/data/datasources/local/user_local_data_source.dart << 'EOL'
abstract class UserLocalDataSource {
  // Define tus métodos locales para usuarios aquí
}
EOL

cat > lib/data/datasources/local/recipe_local_data_source.dart << 'EOL'
abstract class RecipeLocalDataSource {
  // Define tus métodos locales para recetas aquí
}
EOL

## Remote DataSources
cat > lib/data/datasources/remote/user_remote_data_source.dart << 'EOL'
abstract class UserRemoteDataSource {
  // Define tus métodos remotos para usuarios aquí
}
EOL

cat > lib/data/datasources/remote/recipe_remote_data_source.dart << 'EOL'
abstract class RecipeRemoteDataSource {
  // Define tus métodos remotos para recetas aquí
}
EOL

## Models
cat > lib/data/models/user_model.dart << 'EOL'
class UserModel {
  // Implementa tu modelo de usuario aquí
}
EOL

cat > lib/data/models/recipe_model.dart << 'EOL'
class RecipeModel {
  // Implementa tu modelo de receta aquí
}
EOL

## Repository Implementations
cat > lib/data/repositories/user_repository_impl.dart << 'EOL'
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  // Implementa UserRepository aquí
}
EOL

cat > lib/data/repositories/recipe_repository_impl.dart << 'EOL'
import '../../domain/repositories/recipe_repository.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  // Implementa RecipeRepository aquí
}
EOL

# Domain Layer
## Entities
cat > lib/domain/entities/user.dart << 'EOL'
class User {
  // Define tu entidad User aquí
}
EOL

cat > lib/domain/entities/recipe.dart << 'EOL'
class Recipe {
  // Define tu entidad Recipe aquí
}
EOL

## Repository Interfaces
cat > lib/domain/repositories/user_repository.dart << 'EOL'
abstract class UserRepository {
  // Define la interfaz del repositorio de usuarios
}
EOL

cat > lib/domain/repositories/recipe_repository.dart << 'EOL'
abstract class RecipeRepository {
  // Define la interfaz del repositorio de recetas
}
EOL

## Use Cases
cat > lib/domain/usecases/get_user.dart << 'EOL'
import '../repositories/user_repository.dart';

class GetUser {
  final UserRepository repository;

  GetUser(this.repository);

  // Implementa tu caso de uso aquí
}
EOL

cat > lib/domain/usecases/save_user.dart << 'EOL'
import '../repositories/user_repository.dart';

class SaveUser {
  final UserRepository repository;

  SaveUser(this.repository);

  // Implementa tu caso de uso aquí
}
EOL

cat > lib/domain/usecases/get_recipe.dart << 'EOL'
import '../repositories/recipe_repository.dart';

class GetRecipe {
  final RecipeRepository repository;

  GetRecipe(this.repository);

  // Implementa tu caso de uso aquí
}
EOL

cat > lib/domain/usecases/save_recipe.dart << 'EOL'
import '../repositories/recipe_repository.dart';

class SaveRecipe {
  final RecipeRepository repository;

  SaveRecipe(this.repository);

  // Implementa tu caso de uso aquí
}
EOL

# Presentation Layer
## Providers
cat > lib/presentation/providers/user_provider.dart << 'EOL'
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  // Implementa tu provider de usuario aquí
}
EOL

cat > lib/presentation/providers/recipe_provider.dart << 'EOL'
import 'package:flutter/material.dart';

class RecipeProvider with ChangeNotifier {
  // Implementa tu provider de recetas aquí
}
EOL

## Screens
cat > lib/presentation/screens/user_screen.dart << 'EOL'
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Screen')),
      body: Center(child: Text('User Screen Content')),
    );
  }
}
EOL

cat > lib/presentation/screens/recipe_screen.dart << 'EOL'
import 'package:flutter/material.dart';

class RecipeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipe Screen')),
      body: Center(child: Text('Recipe Screen Content')),
    );
  }
}
EOL

## Widgets
cat > lib/presentation/widgets/user_widget.dart << 'EOL'
import 'package:flutter/material.dart';

class UserWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('User Widget'),
    );
  }
}
EOL

cat > lib/presentation/widgets/recipe_widget.dart << 'EOL'
import 'package:flutter/material.dart';

class RecipeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Recipe Widget'),
    );
  }
}
EOL

# Main file
cat > lib/main.dart << 'EOL'
import 'package:flutter/material.dart';
import 'presentation/screens/recipe_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Clean Architecture',
      home: RecipeScreen(),
    );
  }
}
EOL

echo "Estructura de proyecto creada exitosamente!"