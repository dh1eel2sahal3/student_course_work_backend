import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/coursework.dart';
import '../../widgets/custom_button.dart';
import 'submit_coursework_screen.dart';

class CourseworkDetailScreen extends StatelessWidget {
  final Coursework coursework;

  const CourseworkDetailScreen({
    Key? key,
    required this.coursework,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    final isOverdue = coursework.isOverdue;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coursework Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coursework.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (coursework.courseData != null)
                      Chip(
                        avatar: const Icon(Icons.book, size: 16),
                        label: Text(
                          '${coursework.courseData!.code} - ${coursework.courseData!.title}',
                        ),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Deadline: ${dateFormat.format(coursework.deadline)}',
                          style: TextStyle(
                            color: isOverdue ? Colors.red : Colors.grey,
                            fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    if (isOverdue) ...[
                      const SizedBox(height: 8),
                      const Chip(
                        avatar: Icon(Icons.warning, color: Colors.white, size: 16),
                        label: Text(
                          'Overdue',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  coursework.description,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Submit Coursework',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SubmitCourseworkScreen(
                      coursework: coursework,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
