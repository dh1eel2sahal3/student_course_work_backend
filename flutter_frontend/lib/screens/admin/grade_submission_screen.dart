import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/submission.dart';
import '../../services/submission_service.dart';
import '../../widgets/custom_button.dart';

// Shaashadda lagu saxayo shaqooyinka (Grading Screen)
class GradeSubmissionScreen extends StatefulWidget {
  final Submission submission;

  const GradeSubmissionScreen({
    Key? key,
    required this.submission,
  }) : super(key: key);

  @override
  State<GradeSubmissionScreen> createState() => _GradeSubmissionScreenState();
}

class _GradeSubmissionScreenState extends State<GradeSubmissionScreen> {
  final _marksController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.submission.marks != null) {
      _marksController.text = widget.submission.marks.toString();
    }
  }

  @override
  void dispose() {
    _marksController.dispose();
    super.dispose();
  }

  // Shaqada dhibcaha lagu siinayo ardayga
  Future<void> _handleGrade() async {
    final marks = int.tryParse(_marksController.text.trim());
    if (marks == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fadlan geli dhibco sax ah')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updated = await SubmissionService.giveMarks(
        widget.submission.id,
        marks,
      );

      if (updated != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dhibcaha waa la siiyay si guul leh!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sixitaanka Shaqada'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
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
                      widget.submission.courseworkData?.title ?? 'Coursework',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Student: ${widget.submission.studentData?.username ?? "Unknown"}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Submitted: ${widget.submission.createdAt != null ? dateFormat.format(widget.submission.createdAt!) : "N/A"}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Student Answer',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.submission.answer,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Marks',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _marksController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter marks',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            if (widget.submission.isGraded && widget.submission.marks != null) ...[
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
                      'Current Marks: ${widget.submission.marks}',
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
            const SizedBox(height: 32),
            CustomButton(
              text: widget.submission.isGraded ? 'Cusboonaysii Dhibcaha' : 'Sii Dhibcaha',
              onPressed: _handleGrade,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
