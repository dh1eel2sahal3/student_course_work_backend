import 'dart:convert';
import '../config/api_config.dart';
import '../models/coursework.dart';
import 'api_service.dart';

class CourseworkService {
  static Future<List<Coursework>> getCourseworks() async {
    try {
      final response = await ApiService.get(ApiConfig.courseworks);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Coursework.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch courseworks: $e');
    }
  }

  static Future<Coursework?> getCoursework(String id) async {
    try {
      final response = await ApiService.get(ApiConfig.courseworkById(id));
      if (response.statusCode == 200) {
        return Coursework.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch coursework: $e');
    }
  }

  static Future<Coursework?> createCoursework({
    required String title,
    required String description,
    required String course,
    required DateTime deadline,
  }) async {
    try {
      final response = await ApiService.post(
        ApiConfig.courseworks,
        {
          'title': title,
          'description': description,
          'course': course,
          'deadline': deadline.toIso8601String(),
        },
      );
      if (response.statusCode == 201) {
        return Coursework.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to create coursework: $e');
    }
  }

  static Future<Coursework?> updateCoursework(
    String id, {
    String? title,
    String? description,
    String? course,
    DateTime? deadline,
  }) async {
    try {
      final Map<String, dynamic> body = {};
      if (title != null) body['title'] = title;
      if (description != null) body['description'] = description;
      if (course != null) body['course'] = course;
      if (deadline != null) body['deadline'] = deadline.toIso8601String();

      final response = await ApiService.put(
        ApiConfig.courseworkById(id),
        body,
      );
      if (response.statusCode == 200) {
        return Coursework.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to update coursework: $e');
    }
  }

  static Future<bool> deleteCoursework(String id) async {
    try {
      final response = await ApiService.delete(ApiConfig.courseworkById(id));
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to delete coursework: $e');
    }
  }
}
