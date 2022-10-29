import 'package:flutter/src/widgets/framework.dart';

class User {
  int? id;
  String? name;
  String? email;
  String? avatarUrl;
  double? nota1;
  double? nota2;
  double? nota3;

  User({
    this.id,
    this.name,
    this.email,
    this.avatarUrl,
    this.nota1,
    this.nota2,
    this.nota3,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'avatarUrl': avatarUrl,
        'nota1': nota1,
        'nota2': nota2,
        'nota3': nota3,
      };

  static User fromMap(Map<String, dynamic> data) => User(
        id: data['id'] as int?,
        name: data['name'] as String?,
        email: data['email'] as String?,
        avatarUrl: data['avatarUrl'] as String?,
        nota1: data['nota1'] as double?,
        nota2: data['nota2'] as double?,
        nota3: data['nota3'] as double?,
      );
}
