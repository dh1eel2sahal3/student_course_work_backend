import 'package:flutter/material.dart';
import '../../services/coursework_service.dart';
import '../../models/coursework.dart';
import 'coursework_detail_screen.dart';

class CourseworksListScreen extends StatefulWidget {
  const CourseworksListScreen({Key? key}) : super(key: key);

  @override
  State<CourseworksListScreen> createState() => _CourseworksListScreenState();
}

class _CourseworksListScreenState extends State<CourseworksListScreen> {
  List<Coursework> _courseworks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourseworks();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courseworks'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadCourseworks,
              child: _courseworks.isEmpty
                  ? const Center(
                      child: Text('No courseworks available'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _courseworks.length,
                      itemBuilder: (context, index) {
                        final coursework = _courseworks[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: coursework.isOverdue
                                  ? Colors.red
                                  : Colors.blue,
                              child: const Icon(Icons.assignment, color: Colors.white),
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
                                  style: TextStyle(
                                    color: coursework.isOverdue
                                        ? Colors.red
                                        : Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            trailing: coursework.isOverdue
                                ? const Icon(Icons.warning, color: Colors.red)
                                : const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CourseworkDetailScreen(
                                    coursework: coursework,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
