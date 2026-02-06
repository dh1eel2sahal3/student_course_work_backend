import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/course_service.dart';
import '../../services/coursework_service.dart';
import '../../services/submission_service.dart';
import 'users_management_screen.dart';
import 'courses_management_screen.dart';
import 'courseworks_management_screen.dart';
import 'submissions_list_screen.dart';
import '../auth/login_screen.dart';

// Shaashadda weyn ee Maamulaha (Admin Dashboard)
class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _coursesCount = 0;
  int _courseworksCount = 0;
  int _submissionsCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  // Soo qaadashada tirada guud ee xogta (Stats)
  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    try {
      final courses = await CourseService.getCourses();
      final courseworks = await CourseworkService.getCourseworks();
      final submissions = await SubmissionService.getAllSubmissions();

      setState(() {
        _coursesCount = courses.length;
        _courseworksCount = courseworks.length;
        _submissionsCount = submissions.length;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading stats: $e')),
        );
      }
    }
  }

  // Shaqada looga baxayo barnaamijka (Logout)
  Future<void> _handleLogout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStats,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (user != null) ...[
                      // Kaarka xogta qofka soo galay
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: theme.primaryColor,
                            child: const Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(
                            "${user.firstName} ${user.lastName}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Username: ${user.username}\nRole: ${user.role}",
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    // Kaarka tirakoobka (Statistics)
                    Card(
                      color: theme.colorScheme.secondary.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Statistics',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _StatCard(
                                  icon: Icons.book,
                                  label: 'Courses',
                                  value: _coursesCount.toString(),
                                  color: theme.primaryColor,
                                ),
                                _StatCard(
                                  icon: Icons.assignment,
                                  label: 'Courseworks',
                                  value: _courseworksCount.toString(),
                                  color: theme.colorScheme.secondary,
                                ),
                                _StatCard(
                                  icon: Icons.description,
                                  label: 'Submissions',
                                  value: _submissionsCount.toString(),
                                  color: Colors.green, // Allowed neutral secondary
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Management',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Qaybaha maamulka (Grid View)
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _ActionCard(
                          icon: Icons.book,
                          label: 'Courses',
                          color: theme.primaryColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CoursesManagementScreen(),
                              ),
                            );
                          },
                        ),
                        _ActionCard(
                          icon: Icons.assignment,
                          label: 'Courseworks',
                          color: theme.colorScheme.secondary,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CourseworksManagementScreen(),
                              ),
                            );
                          },
                        ),
                        _ActionCard(
                          icon: Icons.description,
                          label: 'Submissions',
                          color: theme.colorScheme.secondary.withOpacity(0.8),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SubmissionsListScreen(),
                              ),
                            );
                          },
                        ),
                        _ActionCard(
                          icon: Icons.people,
                          label: 'Users Management',
                          color: theme.primaryColor.withOpacity(0.8),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const UsersManagementScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
