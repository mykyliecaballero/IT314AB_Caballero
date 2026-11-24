
import 'package:postgres/postgres.dart';

import '../core/db_connection.dart';
import '../models/grade.dart';

class GradeRepository {
  // Get all grades with student and subject details.
  Future<List<Grade>> getGrades() async {
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute('''
      SELECT
        g.grade_id,
        g.enrollment_id,
        g.grade_value,
        g.remarks,
        g.date_recorded,
        CONCAT(st.first_name, ' ', st.last_name) AS student_name,
        sub.subject_code,
        sub.subject_name
      FROM grades g
      JOIN enrollments e
        ON g.enrollment_id = e.enrollment_id
      JOIN students st
        ON e.student_id = st.student_id
      JOIN subjects sub
        ON e.subject_id = sub.subject_id
      ORDER BY g.grade_id
    ''');

    return result.map((row) {
      return Grade.fromMap(row.toColumnMap());
    }).toList();
  }

  // Get enrolled students whose enrollments do not have grades yet.
  Future<List<Map<String, dynamic>>> getUngradedEnrollments() async {
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute('''
      SELECT
        e.enrollment_id,
        CONCAT(st.first_name, ' ', st.last_name) AS student_name,
        sub.subject_code,
        sub.subject_name
      FROM enrollments e
      JOIN students st
        ON e.student_id = st.student_id
      JOIN subjects sub
        ON e.subject_id = sub.subject_id
      LEFT JOIN grades g
        ON e.enrollment_id = g.enrollment_id
      WHERE e.status = 'Enrolled'
        AND g.grade_id IS NULL
      ORDER BY e.enrollment_id
    ''');

    return result.map((row) => row.toColumnMap()).toList();
  }

  // Add a grade to an enrollment.
  Future<void> addGrade({
    required int enrollmentId,
    required double gradeValue,
    required String remarks,
  }) async {
    final connection = await DatabaseConnection.getConnection();

    // Validate the grade range.
    if (gradeValue < 0 || gradeValue > 100) {
      throw Exception('Grade must be between 0 and 100.');
    }

    // Check whether the enrollment exists and is active.
    final enrollmentResult = await connection.execute(
      Sql.named('''
        SELECT enrollment_id
        FROM enrollments
        WHERE enrollment_id = @enrollment_id
          AND status = 'Enrolled'
      '''),
      parameters: {
        'enrollment_id': enrollmentId,
      },
    );

    if (enrollmentResult.isEmpty) {
      throw Exception('Enrollment does not exist or is dropped.');
    }

    // Check whether the enrollment already has a grade.
    final existingGrade = await connection.execute(
      Sql.named('''
        SELECT grade_id
        FROM grades
        WHERE enrollment_id = @enrollment_id
      '''),
      parameters: {
        'enrollment_id': enrollmentId,
      },
    );

    if (existingGrade.isNotEmpty) {
      throw Exception('This enrollment already has a grade.');
    }

    // Save the grade.
    await connection.execute(
      Sql.named('''
        INSERT INTO grades (
          enrollment_id,
          grade_value,
          remarks,
          date_recorded
        )
        VALUES (
          @enrollment_id,
          @grade_value,
          @remarks,
          CURRENT_DATE
        )
      '''),
      parameters: {
        'enrollment_id': enrollmentId,
        'grade_value': gradeValue,
        'remarks': remarks,
      },
    );
  }
}
