import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Profile {
  final String? image;
  final String? name;
  final String? course;
  final String? yearLevel;
  final int? age;
  final String? hobby;
  final String? studentId;
  final String? email;
  final String? favoriteSubject;

  const Profile({
    this.image,
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Set<String> favoriteStudents = {};
  List<Profile> students = [...profiles];

  @override
  Widget build(BuildContext context) {
    final sortedProfiles = [...students];

    sortedProfiles.sort(
      (a, b) => (a.name ?? "").compareTo(b.name ?? ""),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 4, 8),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 1, 1, 100),
          centerTitle: true,
          title: const Text(
            "My First Flutter Application",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: students.isEmpty
            ? const Center(
                child: Text(
                  "No students found.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: sortedProfiles.length,
                itemBuilder: (context, index) {
                  final profile = sortedProfiles[index];

                  final isFavorite =
                      favoriteStudents.contains(profile.studentId);

                  return GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Student card tapped!",
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: isFavorite
                          ? Colors.pink.shade50
                          : const Color.fromARGB(255, 253, 253, 253),
                      elevation: 6,
                      margin: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Image.asset(
                              profile.image!,
                              width: 140,
                              height: 140,
                              fit: BoxFit.cover,
                              cacheWidth: 280,
                              filterQuality: FilterQuality.low,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "💀",
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.add,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "Name: ${profile.name}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Course: ${profile.course}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Year Level: ${profile.yearLevel}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Age: ${profile.age}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Hobby: ${profile.hobby}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Student ID: ${profile.studentId}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Email: ${profile.email}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Favorite Subject: ${profile.favoriteSubject}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      if (favoriteStudents
                                          .contains(profile.studentId)) {
                                        favoriteStudents
                                            .remove(profile.studentId);
                                      } else {
                                        favoriteStudents
                                            .add(profile.studentId!);
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                  ),
                                  label: Text(
                                    isFavorite
                                        ? "Favorited"
                                        : "Favorite",
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                            "Edit Student",
                                          ),
                                          content: Text(
                                            "E edit si ${profile.name}",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                "CLOSE",
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                  label: const Text("Edit"),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      students.remove(profile);
                                      favoriteStudents
                                          .remove(profile.studentId);
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "${profile.name} was removed.",
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.delete),
                                  label: const Text("Delete"),
                                ),
                              ],
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