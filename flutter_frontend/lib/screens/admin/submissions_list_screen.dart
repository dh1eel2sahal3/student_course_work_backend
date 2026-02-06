import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/submission_service.dart';
import '../../models/submission.dart';
import '../../widgets/submission_status_chip.dart';
import 'grade_submission_screen.dart';

// Shaashadda liiska shaqooyinka la soo gudbiyay (Submissions List)
class SubmissionsListScreen extends StatefulWidget {
  const SubmissionsListScreen({Key? key}) : super(key: key);

  @override
  State<SubmissionsListScreen> createState() => _SubmissionsListScreenState();
}

class _SubmissionsListScreenState extends State<SubmissionsListScreen> {
  List<Submission> _submissions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubmissions();
  }

  // Shaqada soo rarista shaqooyinka la soo gudbiyay
  Future<void> _loadSubmissions() async {
    setState(() => _isLoading = true);
    try {
      final submissions = await SubmissionService.getAllSubmissions();
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shaqooyinka la soo Gudbiyay'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadSubmissions,
              child: _submissions.isEmpty
                  ? const Center(child: Text('No submissions available'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _submissions.length,
                      itemBuilder: (context, index) {
                        final submission = _submissions[index];
                        final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: submission.isGraded
                                  ? Colors.green
                                  : theme.colorScheme.secondary,
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
                                Text(
                                  'Student: ${submission.studentData?.username ?? "Unknown"}',
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
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GradeSubmissionScreen(
                                    submission: submission,
                                  ),
                                ),
                              );
                              _loadSubmissions();
                            },
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
