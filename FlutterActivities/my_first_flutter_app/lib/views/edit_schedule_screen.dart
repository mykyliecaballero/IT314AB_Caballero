
import 'package:flutter/material.dart';

import '../models/class_schedule.dart';
import '../models/subject.dart';
import '../repositories/subject_repository.dart';
import '../viewmodels/schedule_viewmodel.dart';

class EditScheduleScreen extends StatefulWidget {
  final ClassSchedule schedule;

  const EditScheduleScreen({
    super.key,
    required this.schedule,
  });

  @override
  State<EditScheduleScreen> createState() =>
      _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  final _formKey = GlobalKey<FormState>();

  final ScheduleViewModel _viewModel = ScheduleViewModel();
  final SubjectRepository _subjectRepository = SubjectRepository();

  final TextEditingController _roomController =
      TextEditingController();

  final TextEditingController _capacityController =
      TextEditingController();

  List<Subject> _subjects = [];

  int? _selectedSubjectId;
  String? _selectedDay;

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  bool _isLoading = true;
  bool _isSaving = false;

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

    _selectedSubjectId = widget.schedule.subjectId;
    _selectedDay = widget.schedule.dayOfWeek;

    _startTime = _parseTime(widget.schedule.startTime);
    _endTime = _parseTime(widget.schedule.endTime);

    _roomController.text = widget.schedule.room;
    _capacityController.text =
        widget.schedule.slotCapacity.toString();

    _loadSubjects();
  }

  TimeOfDay _parseTime(String time) {
    // Remove Time(...) if PostgreSQL returns that format.
    time = time.replaceAll('Time(', '').replaceAll(')', '');

    // Remove fractional seconds if present.
    if (time.contains('.')) {
      time = time.split('.').first;
    }

    final parts = time.split(':');

    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  Future<void> _loadSubjects() async {
    try {
      final subjects = await _subjectRepository.getSubjects();

      if (!mounted) return;

      setState(() {
        _subjects = subjects;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load subjects: $e'),
        ),
      );
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute:00';
  }

  String _displayTime(TimeOfDay? time) {
    if (time == null) {
      return 'Select time';
    }

    return time.format(context);
  }

  Future<void> _selectStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  Future<void> _updateSchedule() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedSubjectId == null ||
        _selectedDay == null ||
        _startTime == null ||
        _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all schedule fields.'),
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
          content: Text('End time must be later than start time.'),
        ),
      );
      return;
    }

    final capacity = int.tryParse(_capacityController.text.trim());

    if (capacity == null || capacity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid slot capacity.'),
        ),
      );
      return;
    }

    final updatedSchedule = ClassSchedule(
      scheduleId: widget.schedule.scheduleId,
      subjectId: _selectedSubjectId!,
      dayOfWeek: _selectedDay!,
      startTime: _formatTime(_startTime!),
      endTime: _formatTime(_endTime!),
      room: _roomController.text.trim(),
      slotCapacity: capacity,
    );

    setState(() {
      _isSaving = true;
    });

    try {
      await _viewModel.updateSchedule(updatedSchedule);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Schedule updated successfully!'),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update schedule: $e'),
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
        title: const Text('Edit Schedule'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
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
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Update Class Schedule',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        DropdownButtonFormField<int>(
                          initialValue: _selectedSubjectId,
                          decoration: const InputDecoration(
                            labelText: 'Subject',
                            border: OutlineInputBorder(),
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

                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          initialValue: _selectedDay,
                          decoration: const InputDecoration(
                            labelText: 'Day of Week',
                            border: OutlineInputBorder(),
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

                        const SizedBox(height: 16),

                        OutlinedButton.icon(
                          onPressed: _selectStartTime,
                          icon: const Icon(Icons.access_time),
                          label: Text(
                            'Start Time: ${_displayTime(_startTime)}',
                          ),
                        ),

                        const SizedBox(height: 12),

                        OutlinedButton.icon(
                          onPressed: _selectEndTime,
                          icon: const Icon(Icons.access_time),
                          label: Text(
                            'End Time: ${_displayTime(_endTime)}',
                          ),
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _roomController,
                          decoration: const InputDecoration(
                            labelText: 'Room',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Please enter a room.';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _capacityController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Slot Capacity',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            final capacity =
                                int.tryParse(value ?? '');

                            if (capacity == null ||
                                capacity <= 0) {
                              return 'Enter a valid capacity.';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        ElevatedButton.icon(
                          onPressed: _isSaving
                              ? null
                              : _updateSchedule,
                          icon: const Icon(Icons.save),
                          label: Text(
                            _isSaving
                                ? 'Updating...'
                                : 'Update Schedule',
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
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
