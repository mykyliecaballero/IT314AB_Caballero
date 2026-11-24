
import 'package:flutter/material.dart';

import '../models/class_schedule.dart';
import '../models/subject.dart';
import '../repositories/subject_repository.dart';
import '../viewmodels/schedule_viewmodel.dart';
import 'edit_schedule_screen.dart';

class ScheduleListScreen extends StatefulWidget {
  const ScheduleListScreen({super.key});

  @override
  State<ScheduleListScreen> createState() =>
      _ScheduleListScreenState();
}

class _ScheduleListScreenState extends State<ScheduleListScreen> {
  final ScheduleViewModel _viewModel = ScheduleViewModel();
  final SubjectRepository _subjectRepository = SubjectRepository();

  List<Subject> _subjects = [];
  bool _isLoadingSubjects = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _viewModel.loadSchedules(),
      _loadSubjects(),
    ]);
  }

  Future<void> _loadSubjects() async {
    try {
      final subjects = await _subjectRepository.getSubjects();

      if (!mounted) return;

      setState(() {
        _subjects = subjects;
        _isLoadingSubjects = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingSubjects = false;
      });
    }
  }

  String _getSubjectName(int subjectId) {
    final matchingSubjects = _subjects.where(
      (subject) => subject.subjectId == subjectId,
    );

    if (matchingSubjects.isEmpty) {
      return 'Unknown Subject';
    }

    final subject = matchingSubjects.first;

    return '${subject.subjectCode} - ${subject.subjectName}';
  }

  Future<void> _addSchedule() async {
    final result = await Navigator.pushNamed(
      context,
      '/add-schedule',
    );

    if (result == true) {
      await _viewModel.loadSchedules();
    }
  }

  Future<void> _editSchedule(ClassSchedule schedule) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return EditScheduleScreen(schedule: schedule);
        },
      ),
    );

    if (result == true) {
      await _viewModel.loadSchedules();
    }
  }

  Future<void> _deleteSchedule(ClassSchedule schedule) async {
    if (schedule.scheduleId == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Schedule'),
        content: const Text(
          'Are you sure you want to delete this schedule?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _viewModel.deleteSchedule(schedule.scheduleId!);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Schedule deleted successfully!'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete schedule: $e'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Schedules'),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addSchedule,
        tooltip: 'Add Schedule',
        child: const Icon(Icons.add),
      ),

      body: _isLoadingSubjects
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : AnimatedBuilder(
              animation: _viewModel,
              builder: (context, child) {
                if (_viewModel.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (_viewModel.errorMessage != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _viewModel.errorMessage!,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _loadData,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (_viewModel.schedules.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _loadData,
                    child: ListView(
                      physics:
                          const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 180),
                        Icon(
                          Icons.calendar_month,
                          size: 65,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Center(
                          child: Text(
                            'No schedules found',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _viewModel.schedules.length,
                    itemBuilder: (context, index) {
                      final schedule =
                          _viewModel.schedules[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getSubjectName(schedule.subjectId),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 12),

                              Text(
                                'Day: ${schedule.dayOfWeek}',
                              ),

                              Text(
                                'Time: ${schedule.startTime} - ${schedule.endTime}',
                              ),

                              Text(
                                'Room: ${schedule.room}',
                              ),

                              Text(
                                'Slot Capacity: ${schedule.slotCapacity}',
                              ),

                              const SizedBox(height: 12),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        _editSchedule(schedule),
                                    icon: const Icon(Icons.edit),
                                    tooltip: 'Edit Schedule',
                                  ),

                                  IconButton(
                                    onPressed: () =>
                                        _deleteSchedule(schedule),
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    tooltip: 'Delete Schedule',
                                  ),
                                ],
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
