import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/student/student_home_screen.dart';
import 'screens/admin/admin_home_screen.dart';
import 'utils/storage_helper.dart';

// Habka guud ee barnaamijka laga bilaabo
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Isticmaalka Provider si loo maamulo xogta barnaamijka oo dhan
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'Student Course Work',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Labada midab ee ugu muhiimsan (Indigo iyo Teal)
          primaryColor: Colors.indigo,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            secondary: Colors.teal,
          ),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

// Qaybtan waxay hubisaa in qofku soo galay (Login) iyo in kale
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  // Hubinta aqoonsiga qofka isticmaalaya app-ka
  Future<void> _checkAuth() async {
    // Mar kasta oo app-ka la furo waa in qofku dib u galo (Login)
    await StorageHelper.clearAll();
    
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Consumer wuxuu la soconayaa xaaladda login-ka
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (!authProvider.isAuthenticated) {
          return const LoginScreen();
        }

        // Haddii uu yahay Admin ama Student, meel gooni ah u gee
        if (authProvider.isAdmin) {
          return const AdminHomeScreen();
        } else {
          return const StudentHomeScreen();
        }
      },
    );
  }
}
