import '../../domain/entities/recipe.dart';

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

  Recipe toEntity() => Recipe(id: id, title: title);
}
