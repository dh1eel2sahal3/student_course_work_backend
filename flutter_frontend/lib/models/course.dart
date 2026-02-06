import 'user.dart';

class Course {
  final String id;
  final String title;
  final String code;
  final String? description;
  final String? createdBy;
  final User? createdByUser;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Course({
    required this.id,
    required this.title,
    required this.code,
    this.description,
    this.createdBy,
    this.createdByUser,
    this.createdAt,
    this.updatedAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      code: json['code'] ?? '',
      description: json['description'],
      createdBy: json['createdBy'] is String 
          ? json['createdBy'] 
          : json['createdBy']?['_id'] ?? json['createdBy']?['id'],
      createdByUser: json['createdBy'] is Map 
          ? User.fromJson(json['createdBy']) 
          : null,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'code': code,
      'description': description,
      'createdBy': createdBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
