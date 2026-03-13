import '../../domain/entities/user.dart';

class UserModel {
  final String id;
  final String title;

  UserModel({required this.id, required this.title});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      title: json['title'],
    );
  }

  User toEntity() => User(id: id, title: title);
}
