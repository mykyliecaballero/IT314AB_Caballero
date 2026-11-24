
class Student {
  final int? studentId;
  final String studentNumber;
  final String firstName;
  final String lastName;
  final String email;
  final String course;
  final int yearLevel;
  final String? contactNumber;

  Student({
    this.studentId,
    required this.studentNumber,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.course,
    required this.yearLevel,
    this.contactNumber,
  });

  String get fullName => '$firstName $lastName';

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      studentId: map['student_id'] as int?,
      studentNumber: map['student_number'] as String,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      email: map['email'] as String,
      course: map['course'] as String,
      yearLevel: map['year_level'] as int,
      contactNumber: map['contact_number'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'student_id': studentId,
      'student_number': studentNumber,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'course': course,
      'year_level': yearLevel,
      'contact_number': contactNumber,
    };
  }
}
