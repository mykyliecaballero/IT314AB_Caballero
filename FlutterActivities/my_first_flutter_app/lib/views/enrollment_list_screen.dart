
import 'package:flutter/material.dart';

import '../models/enrollment.dart';
import '../viewmodels/enrollment_viewmodel.dart';

class EnrollmentListScreen extends StatefulWidget {
  const EnrollmentListScreen({super.key});

  @override
  State<EnrollmentListScreen> createState() =>
      _EnrollmentListScreenState();
}

class _EnrollmentListScreenState extends State<EnrollmentListScreen> {
  final EnrollmentViewModel _viewModel = EnrollmentViewModel();

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

  Future<void> _openAddEnrollment() async {
    final result = await Navigator.pushNamed(
      context,
      '/add-enrollment',
    );

    if (result == true) {
      await _viewModel.loadData();
    }
  }

  Future<void> _dropEnrollment(Enrollment enrollment) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Drop Enrollment'),
        content: const Text(
          'Are you sure you want to drop this enrollment?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Drop'),
          ),
        ],
      ),
    );

    if (confirm != true || enrollment.enrollmentId == null) {
      return;
    }

    try {
      await _viewModel.dropEnrollment(enrollment.enrollmentId!);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enrollment dropped successfully.')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to drop enrollment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enrollments'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 1, 1, 100),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/grade-list');
            },
            icon: const Icon(Icons.grade),
            tooltip: 'Grades',
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, child) {
          if (_viewModel.isLoading && _viewModel.enrollments.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_viewModel.errorMessage != null &&
              _viewModel.enrollments.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(_viewModel.errorMessage!),
              ),
            );
          }

          if (_viewModel.enrollments.isEmpty) {
            return const Center(
              child: Text('No enrollments found.'),
            );
          }

          return RefreshIndicator(
            onRefresh: _viewModel.loadData,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _viewModel.enrollments.length,
              itemBuilder: (context, index) {
                final enrollment = _viewModel.enrollments[index];

                final isEnrolled = enrollment.status == 'Enrolled';

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          enrollment.studentName ?? 'Unknown Student',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${enrollment.subjectCode ?? ''} - '
                          '${enrollment.subjectName ?? 'Unknown Subject'}',
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Day: ${enrollment.dayOfWeek ?? 'N/A'}',
                        ),
                        Text(
                          'Time: ${enrollment.startTime ?? 'N/A'} - '
                          '${enrollment.endTime ?? 'N/A'}',
                        ),
                        Text('Schedule ID: ${enrollment.scheduleId}'),
                        Text('Status: ${enrollment.status}'),
                        const SizedBox(height: 8),
                        if (isEnrolled)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () =>
                                  _dropEnrollment(enrollment),
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                color: Colors.red,
                              ),
                              label: const Text(
                                'Drop Enrollment',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddEnrollment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
