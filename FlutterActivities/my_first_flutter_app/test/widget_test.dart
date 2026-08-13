import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const String name = "Kyla Marie S. Caballero";
const String course = "BSIT 3";
const int age = 20;
const String hobby = "Drawing";
const double height = 1.60;
const bool isStudent = true;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My First Flutter Application',
      home: Scaffold(
        backgroundColor: const Color(0xFF0D1B2A),

        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFF1B263B),
          title: const Text(
            'My First Flutter Application',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Spider Image (outside the white card)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Image.asset(
                  'assets/spider.png',
                  width: 140,
                  height: 140,
                ),
              ),

              // Card 1
              Padding(
                padding: const EdgeInsets.only(top: 10),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                          name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          course,
                          style: const TextStyle(fontSize: 13),
                        ),

                        const SizedBox(height: 15),

                        const Text(
                          "My First Flutter Application",
                          style: TextStyle(
                            fontSize: 24,
                            fontStyle: FontStyle.italic,
                          ),
                        ),

                        const SizedBox(height: 15),

                        const Text(
                          "August 11, 2026",
                          style: TextStyle(fontSize: 13),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          "Talent: $hobby",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Age: $age",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Birthdate: June 4, 2006",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Card 2
              Card(
                elevation: 12,
                color: const Color(0xFFF5F5F5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "My Favorites",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Favorite Movie: Spider-Man",
                        style: TextStyle(fontSize: 15),
                      ),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Favorite Game: Minecraft",
                            style: TextStyle(fontSize: 15),
                          ),
                          const SizedBox(width: 20),
                          const Text(
                            "Favorite Food: Pizza",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}