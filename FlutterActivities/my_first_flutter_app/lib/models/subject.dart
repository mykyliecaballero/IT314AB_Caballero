
class Subject {
  final int? subjectId;
  final String subjectCode;
  final String subjectName;
  final int units;
  final String? description;

  Subject({
    this.subjectId,
    required this.subjectCode,
    required this.subjectName,
    required this.units,
    this.description,
  });

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      subjectId: map['subject_id'] as int?,
      subjectCode: map['subject_code'] as String,
      subjectName: map['subject_name'] as String,
      units: map['units'] as int,
      description: map['description'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subject_id': subjectId,
      'subject_code': subjectCode,
      'subject_name': subjectName,
      'units': units,
      'description': description,
    };
  }
}
