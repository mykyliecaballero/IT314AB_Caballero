
import 'package:flutter/material.dart';

import 'models/student.dart';

import 'views/student_list_screen.dart';
import 'views/student_details_screen.dart';
import 'views/add_student_screen.dart';
import 'views/subject_list_screen.dart';
import 'views/schedule_list_screen.dart';
import 'views/add_schedule_screen.dart';
import 'views/enrollment_list_screen.dart';
import 'views/add_enrollment_screen.dart';
import 'views/grade_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/student-list",

      routes: {
        "/student-list": (context) => const StudentListScreen(),

        "/add-student": (context) => const AddStudentScreen(),

        "/student-details": (context) {
          final student =
              ModalRoute.of(context)!.settings.arguments as Student;

          return StudentDetailsScreen(student: student);
        },

        "/subject-list": (context) => const SubjectListScreen(),

        "/schedule-list": (context) => const ScheduleListScreen(),

        "/add-schedule": (context) => const AddScheduleScreen(),

        "/enrollment-list": (context) => const EnrollmentListScreen(),

        "/add-enrollment": (context) => const AddEnrollmentScreen(),

        "/grade-list": (context) => const GradeListScreen(),
      },
    );
  }
}