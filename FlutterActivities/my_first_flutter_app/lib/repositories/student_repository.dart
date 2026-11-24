
import 'package:postgres/postgres.dart';

import '../core/db_connection.dart';
import '../models/student.dart';

class StudentRepository {
  // Get all students from Neon
  Future<List<Student>> getStudents() async {
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      'SELECT * FROM students ORDER BY student_id',
    );

    return result.map((row) {
      return Student.fromMap(row.toColumnMap());
    }).toList();
  }

  // Add a new student
  Future<void> addStudent(Student student) async {
    final connection = await DatabaseConnection.getConnection();

    await connection.execute(
      Sql.named('''
        INSERT INTO students (
          student_number,
          first_name,
          last_name,
          email,
          course,
          year_level,
          contact_number
        )
        VALUES (
          @student_number,
          @first_name,
          @last_name,
          @email,
          @course,
          @year_level,
          @contact_number
        )
      '''),
      parameters: {
        'student_number': student.studentNumber,
        'first_name': student.firstName,
        'last_name': student.lastName,
        'email': student.email,
        'course': student.course,
        'year_level': student.yearLevel,
        'contact_number': student.contactNumber,
      },
    );
  }

  // Update an existing student
  Future<void> updateStudent(Student student) async {
    final connection = await DatabaseConnection.getConnection();

    if (student.studentId == null) {
      throw Exception('Student ID is required for updating.');
    }

    await connection.execute(
      Sql.named('''
        UPDATE students
        SET
          student_number = @student_number,
          first_name = @first_name,
          last_name = @last_name,
          email = @email,
          course = @course,
          year_level = @year_level,
          contact_number = @contact_number
        WHERE student_id = @student_id
      '''),
      parameters: {
        'student_id': student.studentId,
        'student_number': student.studentNumber,
        'first_name': student.firstName,
        'last_name': student.lastName,
        'email': student.email,
        'course': student.course,
        'year_level': student.yearLevel,
        'contact_number': student.contactNumber,
      },
    );
  }

  // Delete a student
  Future<void> deleteStudent(int studentId) async {
    final connection = await DatabaseConnection.getConnection();

    await connection.execute(
      Sql.named('''
        DELETE FROM students
        WHERE student_id = @student_id
      '''),
      parameters: {
        'student_id': studentId,
      },
    );
  }
}
