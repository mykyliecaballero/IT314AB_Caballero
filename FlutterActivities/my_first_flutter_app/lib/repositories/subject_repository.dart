
import 'package:postgres/postgres.dart';

import '../core/db_connection.dart';
import '../models/subject.dart';

class SubjectRepository {
  // Get all subjects from Neon
  Future<List<Subject>> getSubjects() async {
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      'SELECT * FROM subjects ORDER BY subject_id',
    );

    return result.map((row) {
      return Subject.fromMap(row.toColumnMap());
    }).toList();
  }

  // Add a new subject
  Future<void> addSubject(Subject subject) async {
    final connection = await DatabaseConnection.getConnection();

    await connection.execute(
      Sql.named('''
        INSERT INTO subjects (
          subject_code,
          subject_name,
          units,
          description
        )
        VALUES (
          @subject_code,
          @subject_name,
          @units,
          @description
        )
      '''),
      parameters: {
        'subject_code': subject.subjectCode,
        'subject_name': subject.subjectName,
        'units': subject.units,
        'description': subject.description,
      },
    );
  }

  // Update an existing subject
  Future<void> updateSubject(Subject subject) async {
    final connection = await DatabaseConnection.getConnection();

    if (subject.subjectId == null) {
      throw Exception('Subject ID is required for updating.');
    }

    await connection.execute(
      Sql.named('''
        UPDATE subjects
        SET
          subject_code = @subject_code,
          subject_name = @subject_name,
          units = @units,
          description = @description
        WHERE subject_id = @subject_id
      '''),
      parameters: {
        'subject_id': subject.subjectId,
        'subject_code': subject.subjectCode,
        'subject_name': subject.subjectName,
        'units': subject.units,
        'description': subject.description,
      },
    );
  }

  // Delete a subject
  Future<void> deleteSubject(int subjectId) async {
    final connection = await DatabaseConnection.getConnection();

    await connection.execute(
      Sql.named('''
        DELETE FROM subjects
        WHERE subject_id = @subject_id
      '''),
      parameters: {
        'subject_id': subjectId,
      },
    );
  }
}
