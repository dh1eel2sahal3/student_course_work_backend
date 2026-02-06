import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageHelper {
  static const _storage = FlutterSecureStorage();
  
  // Token management
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }
  
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
  
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }
  
  // User data management
  static Future<void> saveUserData(String userData) async {
    await _storage.write(key: 'user_data', value: userData);
  }
  
  static Future<String?> getUserData() async {
    return await _storage.read(key: 'user_data');
  }
  
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
