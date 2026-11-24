
import 'package:flutter/material.dart';

import '../models/student.dart';
import '../viewmodels/student_viewmodel.dart';

class EditStudentScreen extends StatefulWidget {
  final Student student;

  const EditStudentScreen({
    super.key,
    required this.student,
  });

  @override
  State<EditStudentScreen> createState() =>
      _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  final _studentNumberController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _courseController = TextEditingController();
  final _yearLevelController = TextEditingController();
  final _contactNumberController = TextEditingController();

  final StudentViewModel _viewModel = StudentViewModel();

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    _studentNumberController.text = widget.student.studentNumber;
    _firstNameController.text = widget.student.firstName;
    _lastNameController.text = widget.student.lastName;
    _emailController.text = widget.student.email;
    _courseController.text = widget.student.course;
    _yearLevelController.text = widget.student.yearLevel.toString();
    _contactNumberController.text =
        widget.student.contactNumber ?? '';
  }

  @override
  void dispose() {
    _studentNumberController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _courseController.dispose();
    _yearLevelController.dispose();
    _contactNumberController.dispose();
    _viewModel.dispose();

    super.dispose();
  }

  Future<void> updateStudent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final updatedStudent = Student(
        studentId: widget.student.studentId,
        studentNumber: _studentNumberController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        course: _courseController.text.trim(),
        yearLevel: int.parse(_yearLevelController.text.trim()),
        contactNumber: _contactNumberController.text.trim().isEmpty
            ? null
            : _contactNumberController.text.trim(),
      );

      await _viewModel.updateStudent(updatedStudent);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Student updated successfully!"),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update student: $e"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),

      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,

        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        validator: validator ??
            (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please enter $label";
              }

              return null;
            },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 4, 8),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 1, 100),
        centerTitle: true,

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),

        title: const Text(
          "Edit Student",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Card(
          color: const Color.fromARGB(255, 253, 253, 253),
          elevation: 6,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),

          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Form(
              key: _formKey,

              child: Column(
                children: [
                  const Text(
                    "💀",
                    style: TextStyle(fontSize: 35),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Edit Student Information",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  buildTextField(
                    label: "Student Number",
                    controller: _studentNumberController,
                  ),

                  buildTextField(
                    label: "First Name",
                    controller: _firstNameController,
                  ),

                  buildTextField(
                    label: "Last Name",
                    controller: _lastNameController,
                  ),

                  buildTextField(
                    label: "Email",
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter Email";
                      }

                      if (!RegExp(
                        r'^[^@]+@[^@]+\.[^@]+$',
                      ).hasMatch(value.trim())) {
                        return "Please enter a valid email";
                      }

                      return null;
                    },
                  ),

                  buildTextField(
                    label: "Course",
                    controller: _courseController,
                  ),

                  buildTextField(
                    label: "Year Level (1-4)",
                    controller: _yearLevelController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final year = int.tryParse(value ?? "");

                      if (year == null || year < 1 || year > 4) {
                        return "Enter a year level from 1 to 4";
                      }

                      return null;
                    },
                  ),

                  buildTextField(
                    label: "Contact Number (Optional)",
                    controller: _contactNumberController,
                    keyboardType: TextInputType.phone,
                    validator: (value) => null,
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      onPressed: isSaving ? null : updateStudent,

                      icon: isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.save),

                      label: Text(
                        isSaving ? "Updating..." : "Save Changes",
                      ),

                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
