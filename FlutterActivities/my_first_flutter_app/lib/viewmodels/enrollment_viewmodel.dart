
import 'package:flutter/material.dart';

import '../models/enrollment.dart';
import '../repositories/enrollment_repository.dart';

class EnrollmentViewModel extends ChangeNotifier {
  final EnrollmentRepository _repository = EnrollmentRepository();

  List<Enrollment> _enrollments = [];
  List<Map<String, dynamic>> _students = [];
  List<Map<String, dynamic>> _subjects = [];
  List<Map<String, dynamic>> _schedules = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<Enrollment> get enrollments => _enrollments;
  List<Map<String, dynamic>> get students => _students;
  List<Map<String, dynamic>> get subjects => _subjects;
  List<Map<String, dynamic>> get schedules => _schedules;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _enrollments = await _repository.getEnrollments();
      _students = await _repository.getStudents();
      _subjects = await _repository.getSubjects();
      _schedules = await _repository.getSchedules();
    } catch (e) {
      _errorMessage = 'Failed to load enrollment data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEnrollment({
    required int studentId,
    required int subjectId,
    required int scheduleId,
  }) async {
    try {
      await _repository.addEnrollment(
        studentId: studentId,
        subjectId: subjectId,
        scheduleId: scheduleId,
      );

      await loadData();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> dropEnrollment(int enrollmentId) async {
    try {
      await _repository.dropEnrollment(enrollmentId);
      await loadData();
    } catch (e) {
      _errorMessage = 'Failed to drop enrollment: $e';
      notifyListeners();
      rethrow;
    }
  }
}
