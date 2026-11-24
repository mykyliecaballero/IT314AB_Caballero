
import 'package:postgres/postgres.dart';

import '../core/db_connection.dart';
import '../models/enrollment.dart';

class EnrollmentRepository {
  // Convert PostgreSQL Time values into readable time strings.
  String _formatTime(dynamic value) {
    final time = value.toString();

    final cleanedTime = time
        .replaceFirst('Time(', '')
        .replaceFirst(')', '');

    return cleanedTime.split('.').first;
  }

  // Get all enrollments with student, subject, and schedule details.
  Future<List<Enrollment>> getEnrollments() async {
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute('''
      SELECT
        e.enrollment_id,
        e.student_id,
        e.subject_id,
        e.schedule_id,
        e.status,
        e.enrolled_at,
        CONCAT(st.first_name, ' ', st.last_name) AS student_name,
        sub.subject_code,
        sub.subject_name,
        sch.day_of_week,
        sch.start_time,
        sch.end_time
      FROM enrollments e
      JOIN students st ON e.student_id = st.student_id
      JOIN subjects sub ON e.subject_id = sub.subject_id
      JOIN schedules sch ON e.schedule_id = sch.schedule_id
      ORDER BY e.enrollment_id
    ''');

    return result.map((row) {
      return Enrollment.fromMap(row.toColumnMap());
    }).toList();
  }

  // Get students for the enrollment dropdown.
  Future<List<Map<String, dynamic>>> getStudents() async {
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute('''
      SELECT student_id, first_name, last_name
      FROM students
      ORDER BY last_name, first_name
    ''');

    return result.map((row) => row.toColumnMap()).toList();
  }

  // Get subjects for the enrollment dropdown.
  Future<List<Map<String, dynamic>>> getSubjects() async {
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute('''
      SELECT subject_id, subject_code, subject_name
      FROM subjects
      ORDER BY subject_code
    ''');

    return result.map((row) => row.toColumnMap()).toList();
  }

  // Get schedules for the enrollment dropdown.
  Future<List<Map<String, dynamic>>> getSchedules() async {
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute('''
      SELECT
        schedule_id,
        subject_id,
        day_of_week,
        start_time,
        end_time,
        room,
        slot_capacity
      FROM schedules
      ORDER BY schedule_id
    ''');

    return result.map((row) => row.toColumnMap()).toList();
  }

  // Add an enrollment with validation.
  Future<void> addEnrollment({
    required int studentId,
    required int subjectId,
    required int scheduleId,
  }) async {
    final connection = await DatabaseConnection.getConnection();

    // Check whether the selected schedule belongs to the selected subject.
    final scheduleResult = await connection.execute(
      Sql.named('''
        SELECT
          subject_id,
          day_of_week,
          start_time,
          end_time,
          slot_capacity
        FROM schedules
        WHERE schedule_id = @schedule_id
      '''),
      parameters: {
        'schedule_id': scheduleId,
      },
    );

    if (scheduleResult.isEmpty) {
      throw Exception('Selected schedule does not exist.');
    }

    final schedule = scheduleResult.first.toColumnMap();

    if ((schedule['subject_id'] as num).toInt() != subjectId) {
      throw Exception('The selected schedule does not match the subject.');
    }

    // Check available slots.
    final capacityResult = await connection.execute(
      Sql.named('''
        SELECT COUNT(*) AS total
        FROM enrollments
        WHERE schedule_id = @schedule_id
          AND status = 'Enrolled'
      '''),
      parameters: {
        'schedule_id': scheduleId,
      },
    );

    final enrolledCount =
        (capacityResult.first.toColumnMap()['total'] as num).toInt();

    final capacity = (schedule['slot_capacity'] as num).toInt();

    if (enrolledCount >= capacity) {
      throw Exception('This class schedule is already full.');
    }

    // Check whether the student already has this subject.
    final duplicateResult = await connection.execute(
      Sql.named('''
        SELECT enrollment_id
        FROM enrollments
        WHERE student_id = @student_id
          AND subject_id = @subject_id
          AND status = 'Enrolled'
      '''),
      parameters: {
        'student_id': studentId,
        'subject_id': subjectId,
      },
    );

    if (duplicateResult.isNotEmpty) {
      throw Exception('This student is already enrolled in this subject.');
    }

    // Convert PostgreSQL Time objects into strings.
    final startTime = _formatTime(schedule['start_time']);
    final endTime = _formatTime(schedule['end_time']);

    // Check for overlapping class schedules.
    final conflictResult = await connection.execute(
      Sql.named('''
        SELECT e.enrollment_id
        FROM enrollments e
        JOIN schedules existing
          ON e.schedule_id = existing.schedule_id
        WHERE e.student_id = @student_id
          AND e.status = 'Enrolled'
          AND existing.day_of_week = @day_of_week
          AND existing.start_time < @end_time::time
          AND existing.end_time > @start_time::time
      '''),
      parameters: {
        'student_id': studentId,
        'day_of_week': schedule['day_of_week'].toString(),
        'start_time': startTime,
        'end_time': endTime,
      },
    );

    if (conflictResult.isNotEmpty) {
      throw Exception(
        'Schedule conflict! This student already has a class at that time.',
      );
    }

    // Save the enrollment.
    await connection.execute(
      Sql.named('''
        INSERT INTO enrollments (
          student_id,
          subject_id,
          schedule_id,
          status
        )
        VALUES (
          @student_id,
          @subject_id,
          @schedule_id,
          'Enrolled'
        )
      '''),
      parameters: {
        'student_id': studentId,
        'subject_id': subjectId,
        'schedule_id': scheduleId,
      },
    );
  }

  // Drop an enrollment.
  Future<void> dropEnrollment(int enrollmentId) async {
    final connection = await DatabaseConnection.getConnection();

    await connection.execute(
      Sql.named('''
        UPDATE enrollments
        SET status = 'Dropped'
        WHERE enrollment_id = @enrollment_id
      '''),
      parameters: {
        'enrollment_id': enrollmentId,
      },
    );
  }
}
