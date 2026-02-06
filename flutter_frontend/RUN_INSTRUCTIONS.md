# How to Run the Flutter App

## Quick Start

1. **Navigate to the Flutter project:**
   ```bash
   cd flutter_frontend
   ```

2. **Get dependencies:**
   ```bash
   flutter pub get
   ```

3. **Check for connected devices:**
   ```bash
   flutter devices
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

## If you get build errors:

### For Android:
- Make sure Android Studio is installed
- Run: `flutter doctor` to check setup
- Clean build: `flutter clean` then `flutter pub get`

### For iOS (Mac only):
- Make sure Xcode is installed
- Run: `pod install` in `ios/` directory

### For Web:
```bash
flutter run -d chrome
```

## Important: Update API URL

Before running, update the backend API URL in:
- File: `lib/config/api_config.dart`
- Change: `baseUrl` to match your backend

**For Android Emulator:** Use `http://10.0.2.2:5000/api`
**For iOS Simulator:** Use `http://localhost:5000/api`
**For Physical Device:** Use your computer's IP: `http://YOUR_IP:5000/api`

## Troubleshooting

1. **"Cannot run" error:**
   - Make sure backend is running on port 5000
   - Check API URL in `api_config.dart`
   - Run `flutter clean` and `flutter pub get`

2. **Build errors:**
   - Run `flutter doctor` to check setup
   - Make sure you have a device/emulator connected
   - Try: `flutter run -d <device-id>`

3. **Dependencies issues:**
   - Delete `pubspec.lock`
   - Run `flutter pub get` again
