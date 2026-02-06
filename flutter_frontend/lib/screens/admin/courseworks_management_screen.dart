import 'package:flutter/material.dart';
import '../../services/coursework_service.dart';
import '../../models/coursework.dart';
import 'add_edit_coursework_screen.dart';

// Shaashadda maamulista shaqooyinka koorsada (Courseworks Management)
class CourseworksManagementScreen extends StatefulWidget {
  const CourseworksManagementScreen({Key? key}) : super(key: key);

  @override
  State<CourseworksManagementScreen> createState() => _CourseworksManagementScreenState();
}

class _CourseworksManagementScreenState extends State<CourseworksManagementScreen> {
  List<Coursework> _courseworks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourseworks();
  }

  // Shaqada soo rarista shaqooyinka koorsada ee backend-ka
  Future<void> _loadCourseworks() async {
    setState(() => _isLoading = true);
    try {
      final courseworks = await CourseworkService.getCourseworks();
      setState(() {
        _courseworks = courseworks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading courseworks: $e')),
        );
      }
    }
  }

  // Shaqada tirtirista shaqada koorsada
  Future<void> _deleteCoursework(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tirtir Shaqada Koorsada'),
        content: const Text('Ma hubtaa inaad rabto inaad tirtirto shaqadan?'),
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
        final success = await CourseworkService.deleteCoursework(id);
        if (success) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Coursework deleted successfully'),
                backgroundColor: Colors.green,
              ),
            );
            _loadCourseworks();
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
        title: const Text('Maamulka Shaqooyinka'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadCourseworks,
              child: _courseworks.isEmpty
                  ? const Center(child: Text('No courseworks available'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _courseworks.length,
                      itemBuilder: (context, index) {
                        final coursework = _courseworks[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: theme.colorScheme.secondary,
                              child: Icon(Icons.assignment, color: Colors.white),
                            ),
                            title: Text(
                              coursework.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  coursework.courseData?.title ?? 'Course',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Deadline: ${_formatDate(coursework.deadline)}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AddEditCourseworkScreen(
                                          coursework: coursework,
                                        ),
                                      ),
                                    );
                                    _loadCourseworks();
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteCoursework(coursework.id),
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
              builder: (_) => const AddEditCourseworkScreen(),
            ),
          );
          _loadCourseworks();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
