import 'coursework.dart';
import 'user.dart';

class Submission {
  final String id;
  final String coursework;
  final Coursework? courseworkData;
  final String answer;
  final String student;
  final User? studentData;
  final int? marks;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Submission({
    required this.id,
    required this.coursework,
    this.courseworkData,
    required this.answer,
    required this.student,
    this.studentData,
    this.marks,
    this.createdAt,
    this.updatedAt,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      id: json['_id'] ?? json['id'] ?? '',
      coursework: json['coursework'] is String 
          ? json['coursework'] 
          : json['coursework']?['_id'] ?? json['coursework']?['id'] ?? '',
      courseworkData: json['coursework'] is Map 
          ? Coursework.fromJson(json['coursework']) 
          : null,
      answer: json['answer'] ?? '',
      student: json['student'] is String 
          ? json['student'] 
          : json['student']?['_id'] ?? json['student']?['id'] ?? '',
      studentData: json['student'] is Map 
          ? User.fromJson(json['student']) 
          : null,
      marks: json['marks'],
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
      'coursework': coursework,
      'answer': answer,
      'student': student,
      'marks': marks,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  bool get isGraded => marks != null;
  String get status => isGraded ? 'Graded' : 'Waiting for grading';
}
