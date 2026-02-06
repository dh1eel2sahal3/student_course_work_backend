import 'course.dart';
import 'user.dart';

class Coursework {
  final String id;
  final String title;
  final String description;
  final String course;
  final Course? courseData;
  final DateTime deadline;
  final String? createdBy;
  final User? createdByUser;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Coursework({
    required this.id,
    required this.title,
    required this.description,
    required this.course,
    this.courseData,
    required this.deadline,
    this.createdBy,
    this.createdByUser,
    this.createdAt,
    this.updatedAt,
  });

  factory Coursework.fromJson(Map<String, dynamic> json) {
    String courseId = '';
    Course? course;
    
    if (json['course'] != null) {
      if (json['course'] is String) {
        courseId = json['course'];
      } else if (json['course'] is Map) {
        course = Course.fromJson(json['course']);
        courseId = course.id;
      }
    }
    
    return Coursework(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      course: courseId,
      courseData: course,
      deadline: json['deadline'] != null 
          ? DateTime.parse(json['deadline']) 
          : DateTime.now(),
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
      'description': description,
      'course': course,
      'deadline': deadline.toIso8601String(),
      'createdBy': createdBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  bool get isOverdue => DateTime.now().isAfter(deadline);
}
