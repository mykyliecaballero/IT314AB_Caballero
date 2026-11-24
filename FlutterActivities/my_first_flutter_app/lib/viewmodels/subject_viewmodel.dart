
import 'package:flutter/foundation.dart';

import '../models/subject.dart';
import '../repositories/subject_repository.dart';

class SubjectViewModel extends ChangeNotifier {
  final SubjectRepository _repository = SubjectRepository();

  List<Subject> subjects = [];

  bool isLoading = false;
  String? errorMessage;

  // Load subjects from Neon
  Future<void> loadSubjects() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      subjects = await _repository.getSubjects();
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  // Add a subject
  Future<void> addSubject(Subject subject) async {
    try {
      await _repository.addSubject(subject);
      await loadSubjects();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Update a subject
  Future<void> updateSubject(Subject subject) async {
    try {
      await _repository.updateSubject(subject);
      await loadSubjects();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Delete a subject
  Future<void> deleteSubject(int subjectId) async {
    try {
      await _repository.deleteSubject(subjectId);
      await loadSubjects();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
