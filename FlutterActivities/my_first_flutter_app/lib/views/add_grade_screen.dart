
import 'package:flutter/material.dart';

import '../viewmodels/grade_viewmodel.dart';

class AddGradeScreen extends StatefulWidget {
  const AddGradeScreen({super.key});

  @override
  State<AddGradeScreen> createState() => _AddGradeScreenState();
}

class _AddGradeScreenState extends State<AddGradeScreen> {
  final GradeViewModel _viewModel = GradeViewModel();

  final TextEditingController _gradeController =
      TextEditingController();

  final TextEditingController _remarksController =
      TextEditingController();

  int? _selectedEnrollmentId;

  @override
  void initState() {
    super.initState();

    _viewModel.loadData();
  }

  @override
  void dispose() {
    _gradeController.dispose();
    _remarksController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> saveGrade() async {
    if (_selectedEnrollmentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an enrollment."),
        ),
      );
      return;
    }

    final gradeValue = double.tryParse(
      _gradeController.text.trim(),
    );

    if (gradeValue == null || gradeValue < 0 || gradeValue > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter a valid grade between 0 and 100."),
        ),
      );
      return;
    }

    if (_remarksController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter remarks."),
        ),
      );
      return;
    }

    try {
      await _viewModel.addGrade(
        enrollmentId: _selectedEnrollmentId!,
        gradeValue: gradeValue,
        remarks: _remarksController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Grade added successfully!"),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to add grade: $e"),
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
        centerTitle: true,

        title: const Text(
          "Add Grade",
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
                child: Text(
                  _viewModel.errorMessage!,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (_viewModel.ungradedEnrollments.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "No active ungraded enrollments found.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Card(
              color: const Color.fromARGB(255, 253, 253, 253),
              elevation: 6,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Select Enrollment",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    DropdownButtonFormField<int>(
                      initialValue: _selectedEnrollmentId,

                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Student and Subject",
                      ),

                      items: _viewModel.ungradedEnrollments.map((item) {
                        final enrollmentId =
                            (item['enrollment_id'] as num).toInt();

                        return DropdownMenuItem<int>(
                          value: enrollmentId,
                          child: Text(
                            "${item['student_name']} - ${item['subject_code']}",
                          ),
                        );
                      }).toList(),

                      onChanged: (value) {
                        setState(() {
                          _selectedEnrollmentId = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Grade Value",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: _gradeController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),

                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter grade (0-100)",
                        hintText: "Example: 95.50",
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Remarks",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: _remarksController,

                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter remarks",
                        hintText: "Example: Excellent",
                      ),
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: saveGrade,
                        icon: const Icon(Icons.save),
                        label: const Text("Save Grade"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
