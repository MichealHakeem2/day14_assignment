import 'package:shopping_app/features/auth/data/models/register_response_model.dart';

class LoginResponseModel {
  final String? message;
  final UserData? user;
  final String? token;

  LoginResponseModel({this.message, this.user, this.token});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      message: json['message'],
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      if (user != null) 'user': user!.toJson(),
      'token': token,
    };
  }
}
