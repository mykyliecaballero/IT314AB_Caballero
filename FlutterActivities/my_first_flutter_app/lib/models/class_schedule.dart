
class ClassSchedule {
  final int? scheduleId;
  final int subjectId;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final String room;
  final int slotCapacity;

  const ClassSchedule({
    this.scheduleId,
    required this.subjectId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.slotCapacity,
  });

  factory ClassSchedule.fromMap(Map<String, dynamic> map) {
    return ClassSchedule(
      scheduleId: map['schedule_id'] as int?,
      subjectId: map['subject_id'] as int,
      dayOfWeek: map['day_of_week'] as String,
      startTime: _formatDatabaseTime(map['start_time']),
      endTime: _formatDatabaseTime(map['end_time']),
      room: map['room'] as String,
      slotCapacity: map['slot_capacity'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'schedule_id': scheduleId,
      'subject_id': subjectId,
      'day_of_week': dayOfWeek,
      'start_time': startTime,
      'end_time': endTime,
      'room': room,
      'slot_capacity': slotCapacity,
    };
  }
}

String _formatDatabaseTime(dynamic value) {
  if (value is Duration) {
    final hours = value.inHours.toString().padLeft(2, '0');
    final minutes = (value.inMinutes % 60)
        .toString()
        .padLeft(2, '0');
    final seconds = (value.inSeconds % 60)
        .toString()
        .padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }

  if (value is DateTime) {
    final hours = value.hour.toString().padLeft(2, '0');
    final minutes = value.minute.toString().padLeft(2, '0');
    final seconds = value.second.toString().padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }

  String time = value.toString();

  // Remove the Time(...) wrapper returned by PostgreSQL.
  if (time.startsWith('Time(') && time.endsWith(')')) {
    time = time.substring(5, time.length - 1);
  }

  // Remove fractional seconds, if present.
  if (time.contains('.')) {
    time = time.split('.').first;
  }

  return time;
}
