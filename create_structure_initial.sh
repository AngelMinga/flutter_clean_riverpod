#!/bin/bash

set -e

capitalize() {
  local input=$1
  echo "$(tr '[:lower:]' '[:upper:]' <<< ${input:0:1})${input:1}"
}

create_folders() {
  echo "📁 Creando estructura de carpetas..."

  mkdir -p lib/core/{error,network,storage,usecase,utils,constants}
  mkdir -p lib/features/{user,recipe}
  mkdir -p lib/features/user/{data/{models,datasources,repositories},domain/{entities,repositories,usecases},presentation/{providers,screens,widgets}}
  mkdir -p lib/features/recipe/{data/{models,datasources,repositories},domain/{entities,repositories,usecases},presentation/{providers,screens,widgets}}
  mkdir -p lib/routes

  echo "✅ Carpetas creadas."
}

create_core_files() {
  echo "📄 Creando archivos core..."

  cat > lib/core/error/exceptions.dart << 'EOF'
abstract class AppException implements Exception {
  final String message;
  final StackTrace? stackTrace;
  AppException(this.message, [this.stackTrace]);
}

class ServerException extends AppException {
  ServerException(String message, [StackTrace? stackTrace]) : super(message, stackTrace);
}

class CacheException extends AppException {
  CacheException(String message, [StackTrace? stackTrace]) : super(message, stackTrace);
}
EOF

  cat > lib/core/network/api_client.dart << 'EOF'
import 'package:dio/dio.dart';
import '../error/exceptions.dart';

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
EOF

  cat > lib/core/storage/local_storage.dart << 'EOF'
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
EOF

  cat > lib/core/usecase/usecase.dart << 'EOF'
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

class NoParams {}
EOF

  cat > lib/core/utils/date_formatter.dart << 'EOF'
class DateFormatter {
  static String format(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
EOF

  cat > lib/core/constants/app_constants.dart << 'EOF'
class AppConstants {
  static const String apiBaseUrl = 'https://api.example.com';
  static const Duration connectTimeout = Duration(seconds: 30);
}
EOF

  echo "✅ Archivos core creados."
}

create_feature_files() {
  local feature=$1
  local Feature=$(capitalize "$feature")

  echo "📄 Creando feature: $feature..."

  # Data Layer
  cat > lib/features/$feature/data/models/${feature}_model.dart << EOF
import '../../domain/entities/${feature}.dart';

class ${Feature}Model {
  final String id;
  final String title;

  ${Feature}Model({required this.id, required this.title});

  factory ${Feature}Model.fromJson(Map<String, dynamic> json) {
    return ${Feature}Model(
      id: json['id'],
      title: json['title'],
    );
  }

  ${Feature} toEntity() => ${Feature}(id: id, title: title);
}
EOF

  cat > lib/features/$feature/data/datasources/${feature}_remote_data_source.dart << EOF
import '../models/${feature}_model.dart';

abstract class ${Feature}RemoteDataSource {
  Future<${Feature}Model> get${Feature}(String id);
}
EOF

  cat > lib/features/$feature/data/datasources/${feature}_local_data_source.dart << EOF
import '../models/${feature}_model.dart';

abstract class ${Feature}LocalDataSource {
  Future<void> cache${Feature}(${Feature}Model model);
}
EOF

  cat > lib/features/$feature/data/repositories/${feature}_repository_impl.dart << EOF
import '../../domain/repositories/${feature}_repository.dart';
import '../datasources/${feature}_remote_data_source.dart';
import '../datasources/${feature}_local_data_source.dart';
import '../models/${feature}_model.dart';
import '../../domain/entities/${feature}.dart';

class ${Feature}RepositoryImpl implements ${Feature}Repository {
  final ${Feature}RemoteDataSource remoteDataSource;
  final ${Feature}LocalDataSource localDataSource;

  ${Feature}RepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<${Feature}> get${Feature}(String id) async {
    final model = await remoteDataSource.get${Feature}(id);
    await localDataSource.cache${Feature}(model);
    return model.toEntity();
  }

  @override
  Future<void> save${Feature}(${Feature} entity) async {
    final model = ${Feature}Model(id: entity.id, title: entity.title);
    await localDataSource.cache${Feature}(model);
  }
}
EOF

  # Domain Layer
  cat > lib/features/$feature/domain/entities/${feature}.dart << EOF
class ${Feature} {
  final String id;
  final String title;

  ${Feature}({required this.id, required this.title});
}
EOF

  cat > lib/features/$feature/domain/repositories/${feature}_repository.dart << EOF
import '../entities/${feature}.dart';

abstract class ${Feature}Repository {
  Future<${Feature}> get${Feature}(String id);
  Future<void> save${Feature}(${Feature} entity);
}
EOF

  cat > lib/features/$feature/domain/usecases/get_${feature}.dart << EOF
import '../../../../core/usecase/usecase.dart';
import '../repositories/${feature}_repository.dart';
import '../entities/${feature}.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/${feature}_repository_provider.dart';

final get${Feature}Provider = Provider((ref) => Get${Feature}(ref.watch(${feature}RepositoryProvider)));

class Get${Feature} implements UseCase<${Feature}, String> {
  final ${Feature}Repository repository;

  Get${Feature}(this.repository);

  @override
  Future<${Feature}> call(String id) => repository.get${Feature}(id);
}
EOF

  cat > lib/features/$feature/domain/usecases/save_${feature}.dart << EOF
import '../../../../core/usecase/usecase.dart';
import '../repositories/${feature}_repository.dart';
import '../entities/${feature}.dart';

class Save${Feature} implements UseCase<void, ${Feature}> {
  final ${Feature}Repository repository;

  Save${Feature}(this.repository);

  @override
  Future<void> call(${Feature} entity) => repository.save${Feature}(entity);
}
EOF

  # Presentation Layer
  cat > lib/features/$feature/presentation/providers/${feature}_repository_provider.dart << EOF
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/${feature}_repository_impl.dart';
import '../../data/datasources/${feature}_remote_data_source.dart';
import '../../data/datasources/${feature}_local_data_source.dart';
import '../../domain/repositories/${feature}_repository.dart';
import '../../data/models/${feature}_model.dart';

final ${feature}RepositoryProvider = Provider<${Feature}Repository>((ref) {
  return ${Feature}RepositoryImpl(
    remoteDataSource: Fake${Feature}RemoteDataSource(),
    localDataSource: Fake${Feature}LocalDataSource(),
  );
});

class Fake${Feature}RemoteDataSource implements ${Feature}RemoteDataSource {
  @override
  Future<${Feature}Model> get${Feature}(String id) async {
    return ${Feature}Model(id: id, title: 'Fake ${Feature} \$id');
  }
}

class Fake${Feature}LocalDataSource implements ${Feature}LocalDataSource {
  @override
  Future<void> cache${Feature}(${Feature}Model model) async {}
}
EOF

  cat > lib/features/$feature/presentation/providers/${feature}_provider.dart << EOF
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_${feature}.dart';
import '../../domain/entities/${feature}.dart';

final ${feature}Provider = StateNotifierProvider<${Feature}Notifier, AsyncValue<${Feature}?>>((ref) {
  return ${Feature}Notifier(ref);
});

class ${Feature}Notifier extends StateNotifier<AsyncValue<${Feature}?>> {
  final Ref ref;

  ${Feature}Notifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> fetch${Feature}(String id) async {
    state = const AsyncValue.loading();
    try {
      final item = await ref.read(get${Feature}Provider).call(id);
      state = AsyncValue.data(item);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
EOF

  cat > lib/features/$feature/presentation/screens/${feature}_screen.dart << EOF
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/${feature}_provider.dart';
import '../widgets/${feature}_card.dart';

class ${Feature}Screen extends ConsumerWidget {
  const ${Feature}Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(${feature}Provider);

    return Scaffold(
      appBar: AppBar(title: const Text('${Feature} Details')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: \$e')),
        data: (data) => ${Feature}Card(${feature}: data),
      ),
    );
  }
}
EOF

  cat > lib/features/$feature/presentation/widgets/${feature}_card.dart << EOF
import 'package:flutter/material.dart';
import '../../domain/entities/${feature}.dart';

class ${Feature}Card extends StatelessWidget {
  final ${Feature}? ${feature};

  const ${Feature}Card({super.key, required this.${feature}});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(${feature}?.title ?? 'No ${Feature}'),
        subtitle: Text(${feature}?.id ?? ''),
      ),
    );
  }
}
EOF

  echo "✅ Feature $feature generada."
}

create_main_and_routes() {
  echo "📄 Creando archivo main.dart y rutas..."

  cat > lib/main.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes/app_router.dart';

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
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: '/',
    );
  }
}
EOF

  cat > lib/routes/app_router.dart << 'EOF'
import 'package:flutter/material.dart';
import '../features/recipe/presentation/screens/recipe_screen.dart';

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
EOF

  echo "✅ main.dart y rutas generadas."
}

main() {
  create_folders
  create_core_files
  create_feature_files user
  create_feature_files recipe
  create_main_and_routes
  echo "🎉 Proyecto generado exitosamente."
}

main