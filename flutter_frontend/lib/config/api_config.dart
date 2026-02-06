class ApiConfig {
  // Change this to your backend URL
  // For Android Emulator: use 'http://10.0.2.2:5000/api'
  // For iOS Simulator: use 'http://localhost:5000/api'
  // For Physical Device: use 'http://YOUR_COMPUTER_IP:5000/api'
  static const String baseUrl = 'http://10.0.2.2:5000/api';
  
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String users = '/auth/users';
  
  // Course endpoints
  static const String courses = '/courses';
  static String courseById(String id) => '/courses/$id';
  
  // Coursework endpoints
  static const String courseworks = '/courseworks';
  static String courseworkById(String id) => '/courseworks/$id';
  
  // Submission endpoints
  static const String submissions = '/submissions';
  static const String mySubmissions = '/submissions/my-submissions';
  static String submissionById(String id) => '/submissions/$id';
}
