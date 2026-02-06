import 'dart:convert';
import '../config/api_config.dart';
import '../models/submission.dart';
import 'api_service.dart';

class SubmissionService {
  static Future<Submission?> createSubmission({
    required String coursework,
    required String answer,
  }) async {
    try {
      final response = await ApiService.post(
        ApiConfig.submissions,
        {
          'coursework': coursework,
          'answer': answer,
        },
      );
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Submission.fromJson(data['submission']);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to submit coursework: $e');
    }
  }

  static Future<List<Submission>> getMySubmissions() async {
    try {
      final response = await ApiService.get(ApiConfig.mySubmissions);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Submission.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch submissions: $e');
    }
  }

  static Future<List<Submission>> getAllSubmissions() async {
    try {
      final response = await ApiService.get(ApiConfig.submissions);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Submission.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch submissions: $e');
    }
  }

  static Future<Submission?> giveMarks(String id, int marks) async {
    try {
      final response = await ApiService.put(
        ApiConfig.submissionById(id),
        {'marks': marks},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Submission.fromJson(data['submission']);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to grade submission: $e');
    }
  }
}
