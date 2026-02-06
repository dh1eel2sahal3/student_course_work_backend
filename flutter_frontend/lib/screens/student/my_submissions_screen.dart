import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/submission_service.dart';
import '../../models/submission.dart';
import '../../widgets/submission_status_chip.dart';

class MySubmissionsScreen extends StatefulWidget {
  const MySubmissionsScreen({Key? key}) : super(key: key);

  @override
  State<MySubmissionsScreen> createState() => _MySubmissionsScreenState();
}

class _MySubmissionsScreenState extends State<MySubmissionsScreen> {
  List<Submission> _submissions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubmissions();
  }

  Future<void> _loadSubmissions() async {
    setState(() => _isLoading = true);
    try {
      final submissions = await SubmissionService.getMySubmissions();
      setState(() {
        _submissions = submissions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading submissions: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Submissions'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadSubmissions,
              child: _submissions.isEmpty
                  ? const Center(
                      child: Text('No submissions yet'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _submissions.length,
                      itemBuilder: (context, index) {
                        final submission = _submissions[index];
                        final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ExpansionTile(
                            leading: CircleAvatar(
                              backgroundColor: submission.isGraded
                                  ? Colors.green
                                  : Colors.orange,
                              child: Icon(
                                submission.isGraded
                                    ? Icons.check
                                    : Icons.hourglass_empty,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              submission.courseworkData?.title ?? 'Coursework',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                if (submission.courseworkData?.courseData != null)
                                  Text(
                                    submission.courseworkData!.courseData!.title,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                const SizedBox(height: 4),
                                Text(
                                  'Submitted: ${submission.createdAt != null ? dateFormat.format(submission.createdAt!) : "N/A"}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            trailing: SubmissionStatusChip(
                              isGraded: submission.isGraded,
                              marks: submission.marks,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Your Answer:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(submission.answer),
                                    if (submission.isGraded && submission.marks != null) ...[
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.green[50],
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.green),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.star, color: Colors.green),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Marks: ${submission.marks}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
