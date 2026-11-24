
import 'package:postgres/postgres.dart';

import '../core/db_connection.dart';
import '../models/class_schedule.dart';

class ScheduleRepository {
  // Get all schedules from Neon
  Future<List<ClassSchedule>> getSchedules() async {
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      'SELECT * FROM schedules ORDER BY schedule_id',
    );

    return result.map((row) {
      return ClassSchedule.fromMap(row.toColumnMap());
    }).toList();
  }

  // Add a new schedule
  Future<void> addSchedule(ClassSchedule schedule) async {
    final connection = await DatabaseConnection.getConnection();

    await connection.execute(
      Sql.named('''
        INSERT INTO schedules (
          subject_id,
          day_of_week,
          start_time,
          end_time,
          room,
          slot_capacity
        )
        VALUES (
          @subject_id,
          @day_of_week,
          @start_time,
          @end_time,
          @room,
          @slot_capacity
        )
      '''),
      parameters: {
        'subject_id': schedule.subjectId,
        'day_of_week': schedule.dayOfWeek,
        'start_time': schedule.startTime,
        'end_time': schedule.endTime,
        'room': schedule.room,
        'slot_capacity': schedule.slotCapacity,
      },
    );
  }

  // Update an existing schedule
  Future<void> updateSchedule(ClassSchedule schedule) async {
    final connection = await DatabaseConnection.getConnection();

    if (schedule.scheduleId == null) {
      throw Exception('Schedule ID is required for updating.');
    }

    await connection.execute(
      Sql.named('''
        UPDATE schedules
        SET
          subject_id = @subject_id,
          day_of_week = @day_of_week,
          start_time = @start_time,
          end_time = @end_time,
          room = @room,
          slot_capacity = @slot_capacity
        WHERE schedule_id = @schedule_id
      '''),
      parameters: {
        'schedule_id': schedule.scheduleId,
        'subject_id': schedule.subjectId,
        'day_of_week': schedule.dayOfWeek,
        'start_time': schedule.startTime,
        'end_time': schedule.endTime,
        'room': schedule.room,
        'slot_capacity': schedule.slotCapacity,
      },
    );
  }

  // Delete a schedule
  Future<void> deleteSchedule(int scheduleId) async {
    final connection = await DatabaseConnection.getConnection();

    await connection.execute(
      Sql.named('''
        DELETE FROM schedules
        WHERE schedule_id = @schedule_id
      '''),
      parameters: {
        'schedule_id': scheduleId,
      },
    );
  }
}
