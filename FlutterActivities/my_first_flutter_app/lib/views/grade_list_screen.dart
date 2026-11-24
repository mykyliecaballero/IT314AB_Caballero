
import 'package:flutter/material.dart';

import '../models/grade.dart';
import '../viewmodels/grade_viewmodel.dart';
import 'add_grade_screen.dart';

class GradeListScreen extends StatefulWidget {
  const GradeListScreen({super.key});

  @override
  State<GradeListScreen> createState() => _GradeListScreenState();
}

class _GradeListScreenState extends State<GradeListScreen> {
  final GradeViewModel _viewModel = GradeViewModel();

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

  Future<void> openAddGrade() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddGradeScreen(),
      ),
    );

    if (result == true) {
      await _viewModel.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 4, 8),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 1, 100),
        centerTitle: true,
        title: const Text(
          "Grade List",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, child) {
          if (_viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          if (_viewModel.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 50,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Unable to load grades.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _viewModel.errorMessage!,
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      onPressed: _viewModel.loadData,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Try Again"),
                    ),
                  ],
                ),
              ),
            );
          }

          if (_viewModel.grades.isEmpty) {
            return const Center(
              child: Text(
                "No grades found.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            );
          }

          final List<Grade> grades = [..._viewModel.grades];

          return RefreshIndicator(
            onRefresh: _viewModel.loadData,
            child: ListView.builder(
              itemCount: grades.length,
              itemBuilder: (context, index) {
                final grade = grades[index];

                return Card(
                  color: const Color.fromARGB(255, 253, 253, 253),
                  elevation: 6,
                  margin: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "📚",
                          style: TextStyle(fontSize: 30),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          grade.studentName ?? "Unknown Student",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${grade.subjectCode ?? 'No Code'} - ${grade.subjectName ?? 'Unknown Subject'}",
                          style: const TextStyle(fontSize: 17),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Grade: ${grade.gradeValue.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Remarks: ${grade.remarks ?? 'No remarks'}",
                          style: const TextStyle(fontSize: 17),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Enrollment ID: ${grade.enrollmentId}",
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Date Recorded: ${grade.dateRecorded?.toString().split(' ').first ?? 'Not available'}",
                          style: const TextStyle(fontSize: 15),
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
        onPressed: openAddGrade,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}
