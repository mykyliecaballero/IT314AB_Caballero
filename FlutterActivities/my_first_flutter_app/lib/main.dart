import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const String name = "Kyla Marie S. Caballero";
const String course = "BSIT 3";
const int age = 21;
const String hobby = "Drawing";
const double height = 1.60;
const bool isStudent = true;
const String profileImage = "assets/kylamarie.jpg";

class Profile {
  final String image;
  final String? name;
  final String? course;
  final String? yearLevel;
  final int? age;
  final String? hobby;
  final String? studentId;
  final String? email;
  final String? favoriteSubject;

  const Profile({
    required this.image,
    this.name,
    this.course,
    this.yearLevel,
    this.age,
    this.hobby,
    this.studentId,
    this.email,
    this.favoriteSubject,
  });
}

const List<Profile> profiles = [
  Profile(
    image: "assets/satorugojo.jpg",
    name: "Satoru Gojo",
    course: "BSIT",
    yearLevel: "3rd Year",
    age: 20,
    hobby: "Eating Sweets",
    studentId: "2023-001",
    email: "gojo@student.com",
    favoriteSubject: "Programming",
  ),
  Profile(
    image: "assets/sugurugeto.jpg",
    name: "Suguru Geto",
    course: "BSIT",
    yearLevel: "3rd Year",
    age: 19,
    hobby: "Reading",
    studentId: "2023-002",
    email: "geto@student.com",
    favoriteSubject: "Database",
  ),
  Profile(
    image: "assets/chosokamo.jpg",
    name: "Choso Kamo",
    course: "BSIT",
    yearLevel: "4th Year",
    age: 25,
    hobby: "Spending time with brothers",
    studentId: "2022-003",
    email: "choso@student.com",
    favoriteSubject: "Networking",
  ),
  Profile(
    image: "assets/sukuna.jpg",
    name: "Ryomen Sukuna",
    course: "BSIT",
    yearLevel: "4th Year",
    age: 30,
    hobby: "Eating",
    studentId: "2022-004",
    email: "sukuna@student.com",
    favoriteSubject: "Cybersecurity",
  ),
  Profile(
    image: "assets/makizenin.jpg",
    name: "Maki Zenin",
    course: "BSIT",
    yearLevel: "1st Year",
    age: 20,
    hobby: "Crushing Cans",
    studentId: "2025-005",
    email: "maki@student.com",
    favoriteSubject: "Web Development",
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final sortedProfiles = [...profiles];

    sortedProfiles.sort(
      (a, b) => (a.name ?? "").compareTo(b.name ?? ""),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My First Flutter Application',
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 4, 8),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 1, 1, 100),
          title: const Text(
            'My First Flutter Application',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: profiles.isEmpty
            ? const Center(
                child: Text(
                  "No students found.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: sortedProfiles.length,
                itemBuilder: (context, index) {
                  final profile = sortedProfiles[index];

                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    child: Card(
                      elevation: 12,
                      color: const Color.fromARGB(255, 253, 253, 253),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              profile.image,
                              width: 140,
                              height: 140,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add,
                                  size: 35,
                                ),
                                const SizedBox(width: 15),
                                const Text(
                                  "💀",
                                  style: TextStyle(fontSize: 60),
                                ),
                                const SizedBox(width: 15),
                                const Icon(
                                  Icons.add,
                                  size: 35,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              profile.name ?? "Name: Not provided",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              profile.course ?? "Course: Not provided",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              profile.yearLevel ??
                                  "Year Level: Not provided",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              profile.age != null
                                  ? "Age: ${profile.age}"
                                  : "Age: Not provided",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              profile.hobby ?? "Hobby: Not provided",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              profile.studentId ??
                                  "Student ID: Not provided",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              profile.email ?? "Email: Not provided",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              profile.favoriteSubject ??
                                  "Favorite Subject: Not provided",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}