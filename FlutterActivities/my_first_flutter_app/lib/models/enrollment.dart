
class Enrollment {
  final int? enrollmentId;
  final int studentId;
  final int subjectId;
  final int scheduleId;
  final String? studentName;
  final String? subjectCode;
  final String? subjectName;
  final String? dayOfWeek;
  final String? startTime;
  final String? endTime;
  final String status;
  final DateTime? enrolledAt;

  const Enrollment({
    this.enrollmentId,
    required this.studentId,
    required this.subjectId,
    required this.scheduleId,
    this.studentName,
    this.subjectCode,
    this.subjectName,
    this.dayOfWeek,
    this.startTime,
    this.endTime,
    required this.status,
    this.enrolledAt,
  });

  factory Enrollment.fromMap(Map<String, dynamic> map) {
    return Enrollment(
      enrollmentId: map['enrollment_id'] as int?,
      studentId: map['student_id'] as int,
      subjectId: map['subject_id'] as int,
      scheduleId: map['schedule_id'] as int,
      studentName: map['student_name']?.toString(),
      subjectCode: map['subject_code']?.toString(),
      subjectName: map['subject_name']?.toString(),
      dayOfWeek: map['day_of_week']?.toString(),
      startTime: map['start_time']?.toString(),
      endTime: map['end_time']?.toString(),
      status: map['status'].toString(),
      enrolledAt: map['enrolled_at'] is DateTime
          ? map['enrolled_at'] as DateTime
          : null,
    );
  }
}
