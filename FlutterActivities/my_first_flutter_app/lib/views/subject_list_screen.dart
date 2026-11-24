
import 'package:flutter/material.dart';

import '../models/subject.dart';
import '../viewmodels/subject_viewmodel.dart';
import 'add_subject_screen.dart';
import 'edit_subject_screen.dart';

class SubjectListScreen extends StatefulWidget {
  const SubjectListScreen({super.key});

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  final SubjectViewModel _viewModel = SubjectViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.loadSubjects();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> openAddSubject() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddSubjectScreen(),
      ),
    );

    if (result == true) {
      _viewModel.loadSubjects();
    }
  }

  Future<void> openEditSubject(Subject subject) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSubjectScreen(
          subject: subject,
        ),
      ),
    );

    if (result == true) {
      _viewModel.loadSubjects();
    }
  }

  Future<void> deleteSubject(Subject subject) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Subject'),
          content: Text(
            'Are you sure you want to delete ${subject.subjectCode}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      await _viewModel.deleteSubject(subject.subjectId!);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Subject deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete subject: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 4, 8),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 1, 100),
        title: const Text(
          'Subject List',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddSubject,
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Color.fromARGB(255, 1, 1, 100),
        ),
      ),
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, child) {
          if (_viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (_viewModel.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Error loading subjects:\n${_viewModel.errorMessage}',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (_viewModel.subjects.isEmpty) {
            return const Center(
              child: Text(
                'No subjects found 💀',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _viewModel.loadSubjects,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _viewModel.subjects.length,
              itemBuilder: (context, index) {
                final Subject subject = _viewModel.subjects[index];

                return Card(
                  color: const Color.fromARGB(255, 253, 253, 253),
                  elevation: 8,
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '💀 ${subject.subjectCode}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subject.subjectName,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Units: ${subject.units}'),
                        if (subject.description != null &&
                            subject.description!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text('Description: ${subject.description}'),
                        ],
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => openEditSubject(subject),
                                icon: const Icon(Icons.edit),
                                label: const Text('Edit'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => deleteSubject(subject),
                                icon: const Icon(Icons.delete),
                                label: const Text('Delete'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
