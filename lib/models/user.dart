enum UserRole { admin, user }

// یوز ها 
class UserModel {
  final String name;
  final String email;
  final String phone;
  final String username;
  final String password;
  final String imagePath;
  final UserRole role;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.username,
    required this.password,
    required this.imagePath,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'username': username,
      'password': password,
      'imagePath': imagePath,
      'role': role.name,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      username: map['username'],
      password: map['password'],
      imagePath: map['imagePath'],
      role: map['role'] == 'admin' ? UserRole.admin : UserRole.user,
    );
  }

UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? password,
    String? imagePath,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      username: username,
      password: password ?? this.password,
      imagePath: imagePath ?? this.imagePath,
      role: role,
    );
  }
}
