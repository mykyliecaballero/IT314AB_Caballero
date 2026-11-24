
import 'package:flutter/material.dart';

import '../models/subject.dart';
import '../viewmodels/subject_viewmodel.dart';

class EditSubjectScreen extends StatefulWidget {
  final Subject subject;

  const EditSubjectScreen({
    super.key,
    required this.subject,
  });

  @override
  State<EditSubjectScreen> createState() => _EditSubjectScreenState();
}

class _EditSubjectScreenState extends State<EditSubjectScreen> {
  final _formKey = GlobalKey<FormState>();

  final _subjectCodeController = TextEditingController();
  final _subjectNameController = TextEditingController();
  final _unitsController = TextEditingController();
  final _descriptionController = TextEditingController();

  final SubjectViewModel _viewModel = SubjectViewModel();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _subjectCodeController.text = widget.subject.subjectCode;
    _subjectNameController.text = widget.subject.subjectName;
    _unitsController.text = widget.subject.units.toString();
    _descriptionController.text = widget.subject.description ?? '';
  }

  @override
  void dispose() {
    _subjectCodeController.dispose();
    _subjectNameController.dispose();
    _unitsController.dispose();
    _descriptionController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> updateSubject() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final updatedSubject = Subject(
      subjectId: widget.subject.subjectId,
      subjectCode: _subjectCodeController.text.trim(),
      subjectName: _subjectNameController.text.trim(),
      units: int.parse(_unitsController.text.trim()),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    try {
      await _viewModel.updateSubject(updatedSubject);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Subject updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update subject: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 4, 8),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 1, 100),
        title: const Text(
          'Edit Subject',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          color: const Color.fromARGB(255, 253, 253, 253),
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '💀 Update Subject Information',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),

                  buildTextField(
                    label: 'Subject Code',
                    controller: _subjectCodeController,
                    hint: 'Enter subject code',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the subject code';
                      }
                      return null;
                    },
                  ),

                  buildTextField(
                    label: 'Subject Name',
                    controller: _subjectNameController,
                    hint: 'Enter subject name',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the subject name';
                      }
                      return null;
                    },
                  ),

                  buildTextField(
                    label: 'Units',
                    controller: _unitsController,
                    hint: 'Enter units',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the units';
                      }

                      final units = int.tryParse(value.trim());

                      if (units == null || units <= 0) {
                        return 'Enter a valid positive number';
                      }

                      return null;
                    },
                  ),

                  buildTextField(
                    label: 'Description (Optional)',
                    controller: _descriptionController,
                    hint: 'Enter subject description',
                    maxLines: 3,
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: _isSaving ? null : updateSubject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 1, 1, 100),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSaving
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Update Subject',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
