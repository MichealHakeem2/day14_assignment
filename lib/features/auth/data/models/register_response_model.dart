class RegisterResponseModel {
  final String? message;
  final UserData? user;
  final String? token;

  RegisterResponseModel({this.message, this.user, this.token});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
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

class UserData {
  final String? name;
  final String? email;
  final String? role;

  UserData({this.name, this.email, this.role});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role,
    };
  }
}
