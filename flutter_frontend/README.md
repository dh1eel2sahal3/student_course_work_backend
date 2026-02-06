# Student Course Work Management System - Flutter Frontend

A Flutter mobile application for managing student coursework submissions, built to work with the Node.js/Express backend.

## Features

### Student Features
- Login/Register
- View all available courseworks
- View coursework details and deadlines
- Submit coursework answers
- View own submissions with status (Waiting for grading / Graded)
- View marks for graded submissions

### Admin Features
- Login
- Manage courses (Create, Read, Update, Delete)
- Manage courseworks (Create, Read, Update, Delete)
- View all student submissions
- Grade submissions and assign marks

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Backend API running (default: http://localhost:5000)

## Setup Instructions

1. **Install Flutter dependencies:**
   ```bash
   cd flutter_frontend
   flutter pub get
   ```

2. **Configure API Base URL:**
   - Open `lib/config/api_config.dart`
   - Update `baseUrl` if your backend is running on a different URL
   - For Android emulator, use `http://10.0.2.2:5000/api` instead of `localhost`
   - For iOS simulator, use `http://localhost:5000/api`
   - For physical device, use your computer's IP address: `http://YOUR_IP:5000/api`

3. **Run the app:**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── config/
│   └── api_config.dart      # API endpoints configuration
├── models/                   # Data models
│   ├── user.dart
│   ├── course.dart
│   ├── coursework.dart
│   └── submission.dart
├── services/                 # API service layer
│   ├── api_service.dart
│   ├── auth_service.dart
│   ├── course_service.dart
│   ├── coursework_service.dart
│   └── submission_service.dart
├── providers/                # State management
│   └── auth_provider.dart
├── screens/
│   ├── auth/                 # Authentication screens
│   ├── student/              # Student screens
│   └── admin/                # Admin screens
├── widgets/                  # Reusable widgets
└── utils/                    # Utilities and helpers
```

## Dependencies

- `http`: HTTP client for API calls
- `provider`: State management
- `flutter_secure_storage`: Secure storage for JWT tokens
- `intl`: Date formatting
- `shared_preferences`: Additional local storage

## API Integration

The app integrates with the following backend endpoints:

- **Authentication**: `/api/auth/login`, `/api/auth/register`
- **Courses**: `/api/courses` (CRUD operations)
- **Courseworks**: `/api/courseworks` (CRUD operations)
- **Submissions**: `/api/submissions` (Create, Read, Grade)

## Notes

- JWT tokens are stored securely using `flutter_secure_storage`
- The app automatically navigates based on user role (Student/Admin)
- All API calls include authentication headers when user is logged in
- Error handling and loading states are implemented throughout

## Troubleshooting

1. **Connection Error**: Make sure the backend is running and the API URL is correct
2. **Token Issues**: Try logging out and logging back in
3. **Build Errors**: Run `flutter clean` and `flutter pub get`

## License

ISC
