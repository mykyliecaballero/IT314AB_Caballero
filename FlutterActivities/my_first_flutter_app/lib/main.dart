import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

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
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

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
        ),
      ),
    );
  }
}