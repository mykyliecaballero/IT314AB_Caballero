
import 'package:flutter/material.dart';

import '../models/student.dart';
import '../viewmodels/student_viewmodel.dart';
import 'edit_student_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() =>
      _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final StudentViewModel _viewModel = StudentViewModel();

  @override
  void initState() {
    super.initState();

    _viewModel.loadStudents();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> openEditStudent(Student student) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditStudentScreen(
          student: student,
        ),
      ),
    );

    if (result == true) {
      await _viewModel.loadStudents();
    }
  }

  Future<void> deleteStudent(Student student) async {
    final confirm = await showDialog<bool>(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Student"),

          content: Text(
            "Are you sure you want to delete ${student.fullName}?",
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    try {
      await _viewModel.deleteStudent(student.studentId!);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${student.fullName} deleted successfully!",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete student: $e"),
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
          "Student List",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          // Subject List button
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/subject-list");
            },

            icon: const Icon(
              Icons.menu_book,
              color: Colors.white,
            ),

            tooltip: "Subject List",
          ),

          // Class Schedules button
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/schedule-list");
            },

            icon: const Icon(
              Icons.calendar_month,
              color: Colors.white,
            ),

            tooltip: "Class Schedules",
          ),

          // Enrollments button
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/enrollment-list");
            },

            icon: const Icon(
              Icons.assignment,
              color: Colors.white,
            ),

            tooltip: "Enrollments",
          ),

          // Add Student button
          IconButton(
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                "/add-student",
              );

              if (result == true) {
                await _viewModel.loadStudents();
              }
            },

            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),

      body: AnimatedBuilder(
        animation: _viewModel,

        builder: (context, child) {
          if (_viewModel.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.white,
                  ),

                  SizedBox(height: 15),

                  Text(
                    "Loading students...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
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
                      "Unable to load students.",
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
                      onPressed: () {
                        _viewModel.loadStudents();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Try Again"),
                    ),
                  ],
                ),
              ),
            );
          }

          if (_viewModel.students.isEmpty) {
            return const Center(
              child: Text(
                "No students found.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            );
          }

          final List<Student> students =
              [..._viewModel.students];

          students.sort(
            (a, b) => a.fullName.compareTo(b.fullName),
          );

          return RefreshIndicator(
            onRefresh: _viewModel.loadStudents,

            child: ListView.builder(
              itemCount: students.length,

              itemBuilder: (context, index) {
                final student = students[index];

                return Card(
                  color: const Color.fromARGB(
                    255,
                    253,
                    253,
                    253,
                  ),

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
                          "💀",
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          student.fullName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "${student.course} | ${student.yearLevel}",
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 5),

                        Text(
                          "Student ID: ${student.studentNumber}",
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          "Email: ${student.email}",
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 5),

                        Text(
                          "Contact: ${student.contactNumber ?? 'Not provided'}",
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 15),

                        SizedBox(
                          width: double.infinity,

                          child: ElevatedButton.icon(
                            onPressed: () {
                              openEditStudent(student);
                            },

                            icon: const Icon(Icons.edit),

                            label: const Text("Edit Student"),

                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        SizedBox(
                          width: double.infinity,

                          child: ElevatedButton.icon(
                            onPressed: () {
                              deleteStudent(student);
                            },

                            icon: const Icon(Icons.delete),

                            label: const Text("Delete Student"),

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(12),
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
    );
  }
}
