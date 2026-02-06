import 'package:flutter/material.dart';
import '../../services/course_service.dart';
import '../../models/course.dart';
import 'add_edit_course_screen.dart';

// Shaashadda maamulista koorsooyinka (Courses Management)
class CoursesManagementScreen extends StatefulWidget {
  const CoursesManagementScreen({Key? key}) : super(key: key);

  @override
  State<CoursesManagementScreen> createState() => _CoursesManagementScreenState();
}

class _CoursesManagementScreenState extends State<CoursesManagementScreen> {
  List<Course> _courses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  // Shaqada soo rarista koorsooyinka backend-ka
  Future<void> _loadCourses() async {
    setState(() => _isLoading = true);
    try {
      final courses = await CourseService.getCourses();
      setState(() {
        _courses = courses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading courses: $e')),
        );
      }
    }
  }

  // Shaqada tirtirista koorsada
  Future<void> _deleteCourse(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tirtir Koorsada'),
        content: const Text('Ma hubtaa inaad rabto inaad tirtirto koorsadan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Jooji'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Tirtir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final success = await CourseService.deleteCourse(id);
        if (success) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Course deleted successfully'),
                backgroundColor: Colors.green,
              ),
            );
            _loadCourses();
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maamulka Koorsooyinka'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadCourses,
              child: _courses.isEmpty
                  ? const Center(child: Text('No courses available'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _courses.length,
                      itemBuilder: (context, index) {
                        final course = _courses[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            // Sawirka koorsada oo wareegsan (Course avatar)
                            leading: CircleAvatar(
                              backgroundColor: theme.primaryColor,
                              child: Icon(Icons.book, color: Colors.white),
                            ),
                            title: Text(
                              course.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('Code: ${course.code}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AddEditCourseScreen(course: course),
                                      ),
                                    );
                                    _loadCourses();
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteCourse(course.id),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: Colors.white,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditCourseScreen(),
            ),
          );
          _loadCourses();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
