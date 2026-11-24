
import 'package:flutter/material.dart';

import '../models/student.dart';

class StudentDetailsScreen extends StatelessWidget {
  final Student student;

  const StudentDetailsScreen({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 4, 8),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 1, 100),
        centerTitle: true,

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),

        title: const Text(
          "Student Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Card(
            color: const Color.fromARGB(255, 253, 253, 253),
            elevation: 6,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  const Text(
                    "💀",
                    style: TextStyle(
                      fontSize: 35,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    student.fullName,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Student ID: ${student.studentNumber}",
                    style: const TextStyle(fontSize: 18),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "First Name: ${student.firstName}",
                    style: const TextStyle(fontSize: 18),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Last Name: ${student.lastName}",
                    style: const TextStyle(fontSize: 18),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Email: ${student.email}",
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Course: ${student.course}",
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Year Level: ${student.yearLevel}",
                    style: const TextStyle(fontSize: 18),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Contact Number: ${student.contactNumber ?? 'Not provided'}",
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
