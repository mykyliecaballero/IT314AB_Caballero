
import 'package:flutter/material.dart';

import '../models/class_schedule.dart';
import '../repositories/schedule_repository.dart';

class ScheduleViewModel extends ChangeNotifier {
  final ScheduleRepository _repository = ScheduleRepository();

  List<ClassSchedule> _schedules = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<ClassSchedule> get schedules => _schedules;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // Load schedules from Neon
  Future<void> loadSchedules() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _schedules = await _repository.getSchedules();
    } catch (e) {
      _errorMessage = 'Failed to load schedules: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a schedule
  Future<void> addSchedule(ClassSchedule schedule) async {
    try {
      await _repository.addSchedule(schedule);
      await loadSchedules();
    } catch (e) {
      _errorMessage = 'Failed to add schedule: $e';
      notifyListeners();
      rethrow;
    }
  }

  // Update a schedule
  Future<void> updateSchedule(ClassSchedule schedule) async {
    try {
      await _repository.updateSchedule(schedule);
      await loadSchedules();
    } catch (e) {
      _errorMessage = 'Failed to update schedule: $e';
      notifyListeners();
      rethrow;
    }
  }

  // Delete a schedule
  Future<void> deleteSchedule(int scheduleId) async {
    try {
      await _repository.deleteSchedule(scheduleId);
      await loadSchedules();
    } catch (e) {
      _errorMessage = 'Failed to delete schedule: $e';
      notifyListeners();
      rethrow;
    }
  }
}
