
import 'package:flutter/material.dart';

import '../viewmodels/enrollment_viewmodel.dart';

class AddEnrollmentScreen extends StatefulWidget {
  const AddEnrollmentScreen({super.key});

  @override
  State<AddEnrollmentScreen> createState() =>
      _AddEnrollmentScreenState();
}

class _AddEnrollmentScreenState extends State<AddEnrollmentScreen> {
  final EnrollmentViewModel _viewModel = EnrollmentViewModel();

  int? _selectedStudentId;
  int? _selectedSubjectId;
  int? _selectedScheduleId;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _viewModel.loadData();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _saveEnrollment() async {
    if (_selectedStudentId == null ||
        _selectedSubjectId == null ||
        _selectedScheduleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a student, subject, and schedule.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _viewModel.addEnrollment(
        studentId: _selectedStudentId!,
        subjectId: _selectedSubjectId!,
        scheduleId: _selectedScheduleId!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enrollment added successfully!'),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Enrollment'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 1, 1, 100),
        foregroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, child) {
          if (_viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (_viewModel.errorMessage != null) {
            return Center(
              child: Text(_viewModel.errorMessage!),
            );
          }

          if (_viewModel.students.isEmpty ||
              _viewModel.subjects.isEmpty ||
              _viewModel.schedules.isEmpty) {
            return const Center(
              child: Text(
                'Students, subjects, or schedules are missing.',
              ),
            );
          }

          final availableSchedules =
              _viewModel.schedules.where((schedule) {
            return (schedule['subject_id'] as num).toInt() ==
                _selectedSubjectId;
          }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Select Student',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                DropdownButtonFormField<int>(
                  initialValue: _selectedStudentId,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Choose student',
                  ),
                  items: _viewModel.students.map((student) {
                    return DropdownMenuItem<int>(
                      value: (student['student_id'] as num).toInt(),
                      child: Text(
                        '${student['first_name']} ${student['last_name']}',
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStudentId = value;
                    });
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  'Select Subject',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                DropdownButtonFormField<int>(
                  initialValue: _selectedSubjectId,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Choose subject',
                  ),
                  items: _viewModel.subjects.map((subject) {
                    return DropdownMenuItem<int>(
                      value: (subject['subject_id'] as num).toInt(),
                      child: Text(
                        '${subject['subject_code']} - '
                        '${subject['subject_name']}',
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSubjectId = value;
                      _selectedScheduleId = null;
                    });
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  'Select Schedule',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                DropdownButtonFormField<int>(
                  initialValue: _selectedScheduleId,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Choose schedule',
                  ),
                  items: availableSchedules.map((schedule) {
                    return DropdownMenuItem<int>(
                      value: (schedule['schedule_id'] as num).toInt(),
                      child: Text(
                        '${schedule['day_of_week']} | '
                        '${schedule['start_time']} - '
                        '${schedule['end_time']} | '
                        '${schedule['room']}',
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedScheduleId = value;
                    });
                  },
                ),

                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: _isSaving ? null : _saveEnrollment,
                  child: _isSaving
                      ? const CircularProgressIndicator()
                      : const Text('Save Enrollment'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
