import 'dart:convert';
import '../config/api_config.dart';
import '../models/user.dart';
import 'api_service.dart';

class UserService {
  static Future<List<User>> getUsers() async {
    try {
      final response = await ApiService.get(ApiConfig.users);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  static Future<bool> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await ApiService.post(ApiConfig.register, userData);
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateUser(String id, Map<String, dynamic> userData) async {
    try {
      final response = await ApiService.put('${ApiConfig.users}/$id', userData);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteUser(String id) async {
    try {
      final response = await ApiService.delete('${ApiConfig.users}/$id');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
