
import 'package:flutter/material.dart';

import '../models/class_schedule.dart';
import '../models/subject.dart';
import '../repositories/subject_repository.dart';
import '../viewmodels/schedule_viewmodel.dart';

class AddScheduleScreen extends StatefulWidget {
  const AddScheduleScreen({super.key});

  @override
  State<AddScheduleScreen> createState() =>
      _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final _formKey = GlobalKey<FormState>();

  final ScheduleViewModel _viewModel = ScheduleViewModel();
  final SubjectRepository _subjectRepository = SubjectRepository();

  final TextEditingController _roomController = TextEditingController();
  final TextEditingController _capacityController =
      TextEditingController();

  List<Subject> _subjects = [];

  int? _selectedSubjectId;
  String? _selectedDay;

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  bool _isLoadingSubjects = true;
  bool _isSaving = false;

  String? _subjectError;

  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    _loadSubjects();
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
        _subjectError = 'Failed to load subjects: $e';
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute:00';
  }

  Future<void> _pickStartTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _startTime ?? const TimeOfDay(hour: 8, minute: 0),
    );

    if (pickedTime != null) {
      setState(() {
        _startTime = pickedTime;
      });
    }
  }

  Future<void> _pickEndTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _endTime ?? const TimeOfDay(hour: 10, minute: 0),
    );

    if (pickedTime != null) {
      setState(() {
        _endTime = pickedTime;
      });
    }
  }

  Future<void> _saveSchedule() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedSubjectId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a subject.'),
        ),
      );
      return;
    }

    if (_selectedDay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a day.'),
        ),
      );
      return;
    }

    if (_startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select the start and end times.'),
        ),
      );
      return;
    }

    final startMinutes =
        _startTime!.hour * 60 + _startTime!.minute;

    final endMinutes =
        _endTime!.hour * 60 + _endTime!.minute;

    if (endMinutes <= startMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'End time must be later than start time.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final schedule = ClassSchedule(
      subjectId: _selectedSubjectId!,
      dayOfWeek: _selectedDay!,
      startTime: _formatTime(_startTime!),
      endTime: _formatTime(_endTime!),
      room: _roomController.text.trim(),
      slotCapacity: int.parse(_capacityController.text.trim()),
    );

    try {
      await _viewModel.addSchedule(schedule);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Schedule added successfully!'),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add schedule: $e'),
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

  @override
  void dispose() {
    _roomController.dispose();
    _capacityController.dispose();
    _viewModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Schedule'),
        centerTitle: true,
      ),

      body: _isLoadingSubjects
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _subjectError != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _subjectError!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isLoadingSubjects = true;
                              _subjectError = null;
                            });

                            _loadSubjects();
                          },
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                )
              : _subjects.isEmpty
                  ? const Center(
                      child: Text('No subjects found.'),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(20),

                      child: Form(
                        key: _formKey,

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Subject',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 8),

                            DropdownButtonFormField<int>(
                              initialValue: _selectedSubjectId,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Select Subject',
                              ),
                              items: _subjects.map((subject) {
                                return DropdownMenuItem<int>(
                                  value: subject.subjectId,
                                  child: Text(
                                    '${subject.subjectCode} - ${subject.subjectName}',
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedSubjectId = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a subject.';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            const Text(
                              'Day of the Week',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 8),

                            DropdownButtonFormField<String>(
                              initialValue: _selectedDay,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Select Day',
                              ),
                              items: _days.map((day) {
                                return DropdownMenuItem<String>(
                                  value: day,
                                  child: Text(day),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedDay = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a day.';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            const Text(
                              'Start Time',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 8),

                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: _pickStartTime,
                                icon: const Icon(Icons.access_time),
                                label: Text(
                                  _startTime == null
                                      ? 'Select Start Time'
                                      : _startTime!.format(context),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            const Text(
                              'End Time',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 8),

                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: _pickEndTime,
                                icon: const Icon(Icons.access_time),
                                label: Text(
                                  _endTime == null
                                      ? 'Select End Time'
                                      : _endTime!.format(context),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            const Text(
                              'Room',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 8),

                            TextFormField(
                              controller: _roomController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Room',
                                prefixIcon: Icon(Icons.meeting_room),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty) {
                                  return 'Please enter a room.';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            const Text(
                              'Slot Capacity',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 8),

                            TextFormField(
                              controller: _capacityController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Slot Capacity',
                                prefixIcon: Icon(Icons.people),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty) {
                                  return 'Please enter slot capacity.';
                                }

                                final capacity = int.tryParse(
                                  value.trim(),
                                );

                                if (capacity == null || capacity <= 0) {
                                  return 'Enter a valid capacity greater than zero.';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 30),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _isSaving
                                    ? null
                                    : _saveSchedule,
                                icon: _isSaving
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.save),
                                label: Text(
                                  _isSaving
                                      ? 'Saving...'
                                      : 'Save Schedule',
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
    );
  }
}
