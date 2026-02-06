import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SubmissionStatusChip extends StatelessWidget {
  final bool isGraded;
  final int? marks;

  const SubmissionStatusChip({
    Key? key,
    required this.isGraded,
    this.marks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isGraded) {
      return Chip(
        avatar: const Icon(Icons.check_circle, color: Colors.white, size: 18),
        label: Text(
          marks != null ? 'Graded: $marks' : 'Graded',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(AppConstants.gradedColor),
      );
    } else {
      return Chip(
        avatar: const Icon(Icons.hourglass_empty, color: Colors.white, size: 18),
        label: const Text(
          'Waiting for grading',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(AppConstants.waitingColor),
      );
    }
  }
}
