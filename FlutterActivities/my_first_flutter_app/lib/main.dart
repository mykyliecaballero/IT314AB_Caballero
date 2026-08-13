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
  final int? age;
  final String? hobby;

  const Profile({
    required this.image,
    this.name,
    this.course,
    this.age,
    this.hobby,
  });
}

const List<Profile> profiles = [
  // Profile 1 - Complete
  Profile(
    image: "assets/satorugojo.jpg",
    name: "Satoru Gojo",
    course: "BSIT 3",
    age: 20,
    hobby: "Eating Sweets",
  ),

  // Profile 2 - Hobby is missing
  Profile(
    image: "assets/sugurugeto.jpg",
    name: "Suguru Geto",
    course: "BSIT 3",
    age: 19,
    hobby: null,
  ),

  // Profile 3 - Course is missing
  Profile(
    image: "assets/chosokamo.jpg",
    name: "Choso Kamo",
    course: null,
    age: 25,
    hobby: "Spending time with brothers",
  ),

  // Profile 4 - Name is missing
  Profile(
    image: "assets/sukuna.jpg",
    name: null,
    course: "BSIT 4",
    age: 30,
    hobby: "Eating",
  ),

  // Profile 5 - Age is missing
  Profile(
    image: "assets/makizenin.jpg",
    name: "Make Zenin",
    course: "BSIT 1",
    age: null,
    hobby: "Crushing Cans",
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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

<<<<<<< Updated upstream
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Spider Image (outside the white card)
            Positioned(
              top: 60,
              child: Image.asset(
                'assets/spider.png',
                width: 140,
                height: 140,
              ),
            ),

            // White Card
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Card(
                  elevation: 12,
                  color: const Color(0xFFF5F5F5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "💀",
                          style: TextStyle(fontSize: 60),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Kyla Marie S. Caballero",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),

                        const SizedBox(height: 15),

                        const Text(
                          "BSIT 3",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            color: Color(0xFF333333),
                          ),
                        ),

                        const SizedBox(height: 15),

                        const Text(
                          "My First Flutter Application",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),

                        const SizedBox(height: 15),

                        const Text(
                          "August 4, 2026",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
=======
        // FLAG 6:
        // Allows the user to scroll through all profiles.
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Create one card for every profile
              for (final profile in profiles)
                Padding(
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
                          // Profile Image
                          Image.asset(
                            profile.image,
                            width: 140,
                            height: 140,
                          ),

                          const SizedBox(height: 20),

                          // Skull and icons
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

                          // NAME
                          Text(
                            profile.name ?? "Name: Not provided",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 15),

                          // COURSE
                          Text(
                            profile.course ?? "Course: Not provided",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 15),

                          // AGE
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

                          // HOBBY
                          Text(
                            profile.hobby ?? "Hobby: Not provided",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 30),
            ],
          ),
>>>>>>> Stashed changes
        ),
      ),
    );
  }
}