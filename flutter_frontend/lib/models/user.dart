// Class-kani wuxuu matalaa xogta ardayga ama maamulaha (User Model)
class User {
  final String id;
  final String firstName;
  final String lastName;
  final String sex;
  final String username;
  final String role;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.sex,
    required this.username,
    required this.role,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  /// GET / users (read)
  // Ka bedelidda xogta JSON ee ka timaada server-ka loona bedelayo Class
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      sex: json['sex'] ?? '',
      username: json['username'] ?? '',
      role: json['role'] ?? 'student',
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  /// POST / users (create)
  // U bedelidda xogta Class-ka loona bedelayo JSON si server-ka loogu diro
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'sex': sex,
      'username': username,
      'role': role,
      'isActive': isActive,
    };
  }

  /// PUT / users/:id (update) ❌ _id lama dirayo
  // U bedelidda xogta loo rabo Update-ka
  Map<String, dynamic> toUpdateJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'sex': sex,
      'username': username,
      'role': role,
      'isActive': isActive,
    };
  }

  // Magaca oo buuxa
  String get fullName => '$firstName $lastName';
}