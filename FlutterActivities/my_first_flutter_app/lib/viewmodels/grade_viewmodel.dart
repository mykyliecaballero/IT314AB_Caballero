
import 'package:flutter/material.dart';

import '../models/grade.dart';
import '../repositories/grade_repository.dart';

class GradeViewModel extends ChangeNotifier {
  final GradeRepository _repository = GradeRepository();

  List<Grade> _grades = [];
  List<Map<String, dynamic>> _ungradedEnrollments = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<Grade> get grades => _grades;

  List<Map<String, dynamic>> get ungradedEnrollments =>
      _ungradedEnrollments;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // Load grades and ungraded enrollments.
  Future<void> loadData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _grades = await _repository.getGrades();

      _ungradedEnrollments =
          await _repository.getUngradedEnrollments();
    } catch (e) {
      _errorMessage = 'Failed to load grade data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a grade.
  Future<void> addGrade({
    required int enrollmentId,
    required double gradeValue,
    required String remarks,
  }) async {
    try {
      await _repository.addGrade(
        enrollmentId: enrollmentId,
        gradeValue: gradeValue,
        remarks: remarks,
      );

      await loadData();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
