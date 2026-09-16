import 'package:flutter/material.dart';

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
  final bool? active;

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
    this.active,
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
    active: true,
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
    active: true,
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
    active: true,
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
    active: false,
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
    active: true,
  ),
];

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
          final profile =
              ModalRoute.of(context)!.settings.arguments as Profile;

          return StudentDetailsScreen(
            profile: profile,
          );
        },
      },
    );
  }
}

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final Set<String> favoriteStudents = {};

  List<Profile> students = [...profiles];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sortedProfiles = [...students];

    sortedProfiles.sort(
      (a, b) => (a.name ?? "").compareTo(b.name ?? ""),
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 4, 8),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 1, 100),
        centerTitle: true,

        title: const Text(
          "Student List",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                "/add-student",
              );
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),

      body: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.white,
                  ),

                  SizedBox(height: 15),

                  Text(
                    "Loading students...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            )
          : students.isEmpty
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
                        favoriteStudents.contains(
                      profile.studentId,
                    );

                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          "/student-details",
                          arguments: profile,
                        );
                      },

                      child: Card(
                        color: isFavorite
                            ? Colors.pink.shade50
                            : const Color.fromARGB(
                                255,
                                253,
                                253,
                                253,
                              ),

                        elevation: 6,

                        margin: const EdgeInsets.all(12),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(25),
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(20),

                          child: Column(
                            children: [
                              if (profile.image != null)
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(20),

                                  child: Image.asset(
                                    profile.image!,

                                    width: 140,
                                    height: 140,

                                    fit: BoxFit.cover,

                                    cacheWidth: 280,

                                    filterQuality:
                                        FilterQuality.low,
                                  ),
                                ),

                              const SizedBox(height: 15),

                              const Text(
                                "💀",
                                style: TextStyle(
                                  fontSize: 30,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                profile.name ?? "",

                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight:
                                      FontWeight.bold,
                                ),

                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "${profile.course ?? ""} | ${profile.yearLevel ?? ""}",

                                style: const TextStyle(
                                  fontSize: 17,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                "Age: ${profile.age ?? ""}",

                                style: const TextStyle(
                                  fontSize: 17,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                "Hobby: ${profile.hobby ?? ""}",

                                style: const TextStyle(
                                  fontSize: 17,
                                ),

                                textAlign:
                                    TextAlign.center,
                              ),

                              const SizedBox(height: 5),

                              Text(
                                "Student ID: ${profile.studentId ?? ""}",

                                style: const TextStyle(
                                  fontSize: 17,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                "Email: ${profile.email ?? ""}",

                                style: const TextStyle(
                                  fontSize: 17,
                                ),

                                textAlign:
                                    TextAlign.center,
                              ),

                              const SizedBox(height: 5),

                              Text(
                                "Favorite Subject: ${profile.favoriteSubject ?? ""}",

                                style: const TextStyle(
                                  fontSize: 17,
                                ),

                                textAlign:
                                    TextAlign.center,
                              ),

                              const SizedBox(height: 8),

                              Text(
                                profile.active == true
                                    ? "ACTIVE"
                                    : "INACTIVE",

                                style: TextStyle(
                                  fontSize: 18,

                                  fontWeight:
                                      FontWeight.bold,

                                  color:
                                      profile.active == true
                                          ? Colors.green
                                          : Colors.red,
                                ),
                              ),

                              const SizedBox(height: 8),

                              profile.active == false
                                  ? Container(
                                      padding:
                                          const EdgeInsets.all(
                                        10,
                                      ),

                                      margin:
                                          const EdgeInsets.only(
                                        bottom: 5,
                                      ),

                                      decoration:
                                          BoxDecoration(
                                        color:
                                            Colors.red.shade50,

                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                          15,
                                        ),
                                      ),

                                      child: Text(
                                        "This student is inactive.",

                                        style: TextStyle(
                                          color:
                                              Colors.red.shade800,

                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),

                              const SizedBox(height: 10),

                              Wrap(
                                alignment:
                                    WrapAlignment.center,

                                spacing: 8,

                                runSpacing: 8,

                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        if (favoriteStudents
                                            .contains(
                                          profile.studentId,
                                        )) {
                                          favoriteStudents
                                              .remove(
                                            profile.studentId,
                                          );
                                        } else {
                                          favoriteStudents.add(
                                            profile.studentId!,
                                          );
                                        }
                                      });
                                    },

                                    icon: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons
                                              .favorite_border,
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
                                            title: Text(
                                              "Edit ${profile.name}",
                                            ),

                                            content:
                                                SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,

                                                mainAxisSize:
                                                    MainAxisSize.min,

                                                children: [
                                                  Text(
                                                    "Name: ${profile.name}",
                                                  ),

                                                  Text(
                                                    "Student ID: ${profile.studentId}",
                                                  ),

                                                  Text(
                                                    "Course: ${profile.course}",
                                                  ),

                                                  Text(
                                                    "Year Level: ${profile.yearLevel}",
                                                  ),

                                                  Text(
                                                    "Age: ${profile.age}",
                                                  ),

                                                  Text(
                                                    "Hobby: ${profile.hobby}",
                                                  ),

                                                  Text(
                                                    "Email: ${profile.email}",
                                                  ),

                                                  Text(
                                                    "Favorite Subject: ${profile.favoriteSubject}",
                                                  ),

                                                  Text(
                                                    profile.active ==
                                                            true
                                                        ? "Status: Active"
                                                        : "Status: Inactive",
                                                  ),
                                                ],
                                              ),
                                            ),

                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(
                                                    context,
                                                  );
                                                },

                                                child:
                                                    const Text(
                                                  "Close",
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },

                                    icon: const Icon(
                                      Icons.edit,
                                    ),

                                    label: const Text(
                                      "Edit",
                                    ),
                                  ),

                                  if (profile.active == true)
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          students.remove(
                                            profile,
                                          );

                                          favoriteStudents
                                              .remove(
                                            profile.studentId,
                                          );
                                        });

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "${profile.name} was removed.",
                                            ),
                                          ),
                                        );
                                      },

                                      icon: const Icon(
                                        Icons.delete,
                                      ),

                                      label: const Text(
                                        "Delete",
                                      ),
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
    );
  }
}

class StudentDetailsScreen extends StatelessWidget {
  final Profile profile;

  const StudentDetailsScreen({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 0, 4, 8),

      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 1, 1, 100),

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
            color: const Color.fromARGB(
              255,
              253,
              253,
              253,
            ),

            elevation: 6,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  if (profile.image != null)
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(20),

                      child: Image.asset(
                        profile.image!,

                        width: 180,
                        height: 180,

                        fit: BoxFit.cover,
                      ),
                    ),

                  const SizedBox(height: 20),

                  Text(
                    profile.name ?? "",

                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),

                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Student ID: ${profile.studentId ?? ""}",

                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Course: ${profile.course ?? ""}",

                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Year Level: ${profile.yearLevel ?? ""}",

                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Age: ${profile.age ?? ""}",

                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Hobby: ${profile.hobby ?? ""}",

                    style: const TextStyle(
                      fontSize: 18,
                    ),

                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Email: ${profile.email ?? ""}",

                    style: const TextStyle(
                      fontSize: 18,
                    ),

                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Favorite Subject: ${profile.favoriteSubject ?? ""}",

                    style: const TextStyle(
                      fontSize: 18,
                    ),

                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 15),

                  Text(
                    profile.active == true
                        ? "Status: Active"
                        : "Status: Inactive",

                    style: TextStyle(
                      fontSize: 18,

                      fontWeight: FontWeight.bold,

                      color: profile.active == true
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,

                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "Edit ${profile.name}",
                            ),

                            content:
                                SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                mainAxisSize:
                                    MainAxisSize.min,

                                children: [
                                  Text(
                                    "Name: ${profile.name}",
                                  ),

                                  Text(
                                    "Student ID: ${profile.studentId}",
                                  ),

                                  Text(
                                    "Course: ${profile.course}",
                                  ),

                                  Text(
                                    "Year Level: ${profile.yearLevel}",
                                  ),

                                  Text(
                                    "Age: ${profile.age}",
                                  ),

                                  Text(
                                    "Hobby: ${profile.hobby}",
                                  ),

                                  Text(
                                    "Email: ${profile.email}",
                                  ),

                                  Text(
                                    "Favorite Subject: ${profile.favoriteSubject}",
                                  ),

                                  Text(
                                    profile.active == true
                                        ? "Status: Active"
                                        : "Status: Inactive",
                                  ),
                                ],
                              ),
                            ),

                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(
                                    context,
                                  );
                                },

                                child: const Text(
                                  "Close",
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },

                    icon: const Icon(
                      Icons.edit,
                    ),

                    label: const Text(
                      "Edit",
                    ),
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

class AddStudentScreen extends StatelessWidget {
  const AddStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 0, 4, 8),

      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 1, 1, 100),

        centerTitle: true,

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),

        title: const Text(
          "Add Student",

          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: const Center(
        child: Text(
          "Add Student Screen",

          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}