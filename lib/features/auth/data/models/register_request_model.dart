class RegisterRequestModel {
  final String name;
  final String phone;
  final String email;
  final String password;
  final String rePassword;

  RegisterRequestModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.rePassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'confirmPassword': rePassword,
      'rePassword': rePassword,
    };
  }

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    return RegisterRequestModel(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      rePassword: json['rePassword'] ?? '',
    );
  }
}
