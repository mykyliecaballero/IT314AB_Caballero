
class Grade {
  final int? gradeId;
  final int enrollmentId;
  final double gradeValue;
  final String? remarks;
  final DateTime? dateRecorded;

  final String? studentName;
  final String? subjectCode;
  final String? subjectName;

  const Grade({
    this.gradeId,
    required this.enrollmentId,
    required this.gradeValue,
    this.remarks,
    this.dateRecorded,
    this.studentName,
    this.subjectCode,
    this.subjectName,
  });

  factory Grade.fromMap(Map<String, dynamic> map) {
    return Grade(
      gradeId: map['grade_id'] == null
          ? null
          : int.tryParse(map['grade_id'].toString()),

      enrollmentId:
          int.tryParse(map['enrollment_id'].toString()) ?? 0,

      gradeValue:
          double.tryParse(map['grade_value'].toString()) ?? 0.0,

      remarks: map['remarks']?.toString(),

      dateRecorded: map['date_recorded'] is DateTime
          ? map['date_recorded'] as DateTime
          : map['date_recorded'] != null
              ? DateTime.tryParse(
                  map['date_recorded'].toString(),
                )
              : null,

      studentName: map['student_name']?.toString(),
      subjectCode: map['subject_code']?.toString(),
      subjectName: map['subject_name']?.toString(),
    );
  }
}
