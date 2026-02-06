import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/coursework_service.dart';
import '../../services/course_service.dart';
import '../../models/coursework.dart';
import '../../models/course.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

// Shaashadda lagu darayo ama lagu wax ka bedelayo shaqada koorsada (Coursework)
class AddEditCourseworkScreen extends StatefulWidget {
  final Coursework? coursework;

  const AddEditCourseworkScreen({Key? key, this.coursework}) : super(key: key);

  @override
  State<AddEditCourseworkScreen> createState() => _AddEditCourseworkScreenState();
}

class _AddEditCourseworkScreenState extends State<AddEditCourseworkScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<Course> _courses = [];
  String? _selectedCourseId;
  DateTime? _selectedDeadline;
  bool _isLoading = false;
  bool _loadingCourses = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
    if (widget.coursework != null) {
      _titleController.text = widget.coursework!.title;
      _descriptionController.text = widget.coursework!.description;
      _selectedCourseId = widget.coursework!.course;
      _selectedDeadline = widget.coursework!.deadline;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadCourses() async {
    try {
      final courses = await CourseService.getCourses();
      setState(() {
        _courses = courses;
        _loadingCourses = false;
      });
    } catch (e) {
      setState(() => _loadingCourses = false);
    }
  }

  Future<void> _selectDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDeadline ?? DateTime.now()),
      );
      if (time != null) {
        setState(() {
          _selectedDeadline = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  // Shaqada lagu keydinayo shaqada koorsada (New or Update)
  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCourseId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fadlan dooro koorsada')),
        );
        return;
      }
      if (_selectedDeadline == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fadlan dooro taariikhda u dambaysa')),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        if (widget.coursework == null) {
          // Create new coursework
          final coursework = await CourseworkService.createCoursework(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            course: _selectedCourseId!,
            deadline: _selectedDeadline!,
          );
          if (coursework != null && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Shaqada koorsada waa lagu daray!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          }
        } else {
          // Update existing coursework
          final coursework = await CourseworkService.updateCoursework(
            widget.coursework!.id,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            course: _selectedCourseId,
            deadline: _selectedDeadline,
          );
          if (coursework != null && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Shaqada koorsada waa la cusboonaysiiyay!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cillad: ${e.toString()}'),
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coursework == null ? 'Ku dar Shaqo' : 'Wax ka bedel Shaqada'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _loadingCourses
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextField(
                      label: 'Title',
                      controller: _titleController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter coursework title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedCourseId,
                      decoration: InputDecoration(
                        labelText: 'Course',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      items: _courses.map((course) {
                        return DropdownMenuItem(
                          value: course.id,
                          child: Text('${course.code} - ${course.title}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCourseId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a course';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: _selectDeadline,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Deadline',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        child: Text(
                          _selectedDeadline != null
                              ? DateFormat('dd MMM yyyy, hh:mm a').format(_selectedDeadline!)
                              : 'Select deadline',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Description',
                      controller: _descriptionController,
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter coursework description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      text: widget.coursework == null ? 'Create Coursework' : 'Update Coursework',
                      onPressed: _handleSave,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
