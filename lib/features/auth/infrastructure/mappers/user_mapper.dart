import 'package:teslo_shop/features/auth/domain/domain.dart';

class UserMapper {
  //el json que recibe es el que viene del backend osea que acepta un json y devuelve un mapa
  static User userJsonToEntity(Map<String, dynamic> json) => User(
      id: json['id'],
      email: json['email'],
      fullName: json['fullName'],
      roles: List<String>.from(json['roles'].map((role) => role)),
      token: json['token']);
}
