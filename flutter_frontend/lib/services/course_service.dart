import 'dart:convert';
import '../config/api_config.dart';
import '../models/course.dart';
import 'api_service.dart';

class CourseService {
  static Future<List<Course>> getCourses() async {
    try {
      final response = await ApiService.get(ApiConfig.courses);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Course.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch courses: $e');
    }
  }

  static Future<Course?> getCourse(String id) async {
    try {
      final response = await ApiService.get(ApiConfig.courseById(id));
      if (response.statusCode == 200) {
        return Course.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch course: $e');
    }
  }

  static Future<Course?> createCourse({
    required String title,
    required String code,
    String? description,
  }) async {
    try {
      final response = await ApiService.post(
        ApiConfig.courses,
        {
          'title': title,
          'code': code,
          if (description != null) 'description': description,
        },
      );
      if (response.statusCode == 201) {
        return Course.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to create course: $e');
    }
  }

  static Future<Course?> updateCourse(
    String id, {
    String? title,
    String? code,
    String? description,
  }) async {
    try {
      final Map<String, dynamic> body = {};
      if (title != null) body['title'] = title;
      if (code != null) body['code'] = code;
      if (description != null) body['description'] = description;

      final response = await ApiService.put(
        ApiConfig.courseById(id),
        body,
      );
      if (response.statusCode == 200) {
        return Course.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to update course: $e');
    }
  }

  static Future<bool> deleteCourse(String id) async {
    try {
      final response = await ApiService.delete(ApiConfig.courseById(id));
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to delete course: $e');
    }
  }
}
