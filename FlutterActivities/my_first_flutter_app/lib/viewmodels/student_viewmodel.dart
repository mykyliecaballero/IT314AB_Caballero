
import 'package:flutter/foundation.dart';

import '../models/student.dart';
import '../repositories/student_repository.dart';

class StudentViewModel extends ChangeNotifier {
  final StudentRepository _repository = StudentRepository();

  List<Student> students = [];

  bool isLoading = false;
  String? errorMessage;

  // Load students from Neon
  Future<void> loadStudents() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      students = await _repository.getStudents();
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  // Add a student
  Future<void> addStudent(Student student) async {
    try {
      await _repository.addStudent(student);
      await loadStudents();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Update a student
  Future<void> updateStudent(Student student) async {
    try {
      await _repository.updateStudent(student);
      await loadStudents();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Delete a student
  Future<void> deleteStudent(int studentId) async {
    try {
      await _repository.deleteStudent(studentId);
      await loadStudents();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
