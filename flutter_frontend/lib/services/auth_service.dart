import 'dart:convert';
import '../config/api_config.dart';
import '../utils/storage_helper.dart';
import 'api_service.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await ApiService.post(
        ApiConfig.login,
        {
          'username': username,
          'password': password,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = data['token'];
        await StorageHelper.saveToken(token);
        return {'success': true, 'token': token};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String sex,
    required String username,
    required String password,
    String role = 'student',
  }) async {
    try {
      final response = await ApiService.post(
        ApiConfig.register,
        {
          'firstName': firstName,
          'lastName': lastName,
          'sex': sex,
          'username': username,
          'password': password,
          'role': role,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {'success': true, 'message': data['message'] ?? 'Registration successful'};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  static Future<void> logout() async {
    await StorageHelper.clearAll();
  }

  static Future<String?> getToken() async {
    return await StorageHelper.getToken();
  }
}
