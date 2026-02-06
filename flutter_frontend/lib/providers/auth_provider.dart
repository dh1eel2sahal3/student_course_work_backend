import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../utils/storage_helper.dart';
import '../utils/constants.dart';
import '../utils/jwt_helper.dart';

// Class-kani wuxuu maamulaa galitaanka iyo bixitaanka (Auth State)
class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;

  // Helista xogta user-ka
  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Hubinta in qofku soo galay iyo in kale
  bool get isAuthenticated => _token != null && _user != null;
  bool get isStudent => _user?.role == AppConstants.roleStudent;
  bool get isAdmin => _user?.role == AppConstants.roleAdmin;

  AuthProvider() {
    // _loadToken logic disabled
  }

  // Soo qaadashada token-ka keydsan
  Future<void> _loadToken() async {
    _token = await StorageHelper.getToken();
    if (_token != null) {
      _decodeAndSetUser(_token!);
      notifyListeners();
    }
  }

  // Furista token-ka si loo ogaado xogta user-ka
  void _decodeAndSetUser(String token) {
    final decoded = JwtHelper.decodeToken(token);
    if (decoded != null) {
      _user = User(
        id: decoded['id'] ?? '',
        firstName: '',
        lastName: '',
        sex: '',
        username: '',
        role: decoded['role'] ?? 'student',
        isActive: true,
      );
    }
  }

  // Shaqada Login-ka
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await AuthService.login(username, password);
      
      if (result['success'] == true) {
        _token = result['token'];
        _decodeAndSetUser(_token!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = result['message'] ?? 'Login failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'An error occurred: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Shaqada is-diiwaangelinta (Registration)
  Future<bool> register({
    required String firstName,
    required String lastName,
    required String sex,
    required String username,
    required String password,
    String role = 'student',
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await AuthService.register(
        firstName: firstName,
        lastName: lastName,
        sex: sex,
        username: username,
        password: password,
        role: role,
      );

      if (result['success'] == true) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = result['message'] ?? 'Registration failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'An error occurred: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Shaqada looga baxayo app-ka (Logout)
  Future<void> logout() async {
    await AuthService.logout();
    _user = null;
    _token = null;
    _error = null;
    notifyListeners();
  }

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
