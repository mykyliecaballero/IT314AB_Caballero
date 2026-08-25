import 'package:flutter/material.dart';

String map = "Ascent";
String mode = "Competitive";
String date = "22/08/2026";
String time = "42:01 Min";
String result = "Defeat";

int score1 = 12;
int score2 = 14;

String image = "assets/ascent.jpg";

List<Map<String, dynamic>> team1 = [
  {
    "name": "Scyn4pse",
    "score": 261,
    "kills": 23,
    "deaths": 21,
    "assists": 6,
    "image": "assets/phoenix.webp",
    "mvp": false,
  },
  {
    "name": "Chinese Name",
    "score": 190,
    "kills": 17,
    "deaths": 21,
    "assists": 8,
    "image": "assets/chamber.webp",
    "mvp": false,
  },
  {
    "name": "Dabid",
    "score": 89,
    "kills": 9,
    "deaths": 8,
    "assists": 1,
    "image": "assets/brimstone.webp",
    "mvp": false,
  },
  {
    "name": "Chinese Name",
    "score": 298,
    "kills": 28,
    "deaths": 23,
    "assists": 6,
    "image": "assets/clove.webp",
    "mvp": true,
  },
  {
    "name": "noobsaur",
    "score": 259,
    "kills": 21,
    "deaths": 21,
    "assists": 10,
    "image": "assets/reyna.webp",
    "mvp": false,
  },
];

List<Map<String, dynamic>> team2 = [
  {
    "name": "tlbvay",
    "score": 219,
    "kills": 20,
    "deaths": 18,
    "assists": 5,
    "image": "assets/chamber.webp",
    "mvp": false,
  },
  {
    "name": "Kreiz",
    "score": 191,
    "kills": 18,
    "deaths": 21,
    "assists": 2,
    "image": "assets/reyna.webp",
    "mvp": false,
  },
  {
    "name": "TranHoang17",
    "score": 203,
    "kills": 19,
    "deaths": 19,
    "assists": 4,
    "image": "assets/raze.webp",
    "mvp": false,
  },
  {
    "name": "Neithl",
    "score": 246,
    "kills": 23,
    "deaths": 21,
    "assists": 5,
    "image": "assets/sova.webp",
    "mvp": true,
  },
  {
    "name": "clutch bus cuk",
    "score": 159,
    "kills": 13,
    "deaths": 19,
    "assists": 9,
    "image": "assets/brimstone.webp",
    "mvp": false,
  },
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MatchPage(),
    );
  }
}

class MatchPage extends StatelessWidget {
  const MatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1B1D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF151213),
        leading: const Icon(Icons.arrow_back_ios),
        title: const Text(
          "Match Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "My Team",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  "$score1  ⚔  $score2",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Text(
                  "Opponent",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            Image.asset(
              image,
              width: double.infinity,
              height: 230,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  const Icon(
                    Icons.shield,
                    color: Colors.amber,
                    size: 40,
                  ),

                  const SizedBox(width: 10),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$map - $mode",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "$date  $time",
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      result,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            teamTitle("My Team"),

            for (Map<String, dynamic> player in team1)
              playerRow(player),

            teamTitle("Opponent"),

            for (Map<String, dynamic> player in team2)
              playerRow(player),
          ],
        ),
      ),
    );
  }

  Widget teamTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      color: const Color(0xFF302C2E),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget playerRow(Map<String, dynamic> player) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: const Color(0xFF211E20),
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade800,
          ),
        ),
      ),

      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              player["image"],
              width: 65,
              height: 65,
              fit: BoxFit.cover,

              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return const Icon(
                  Icons.person,
                  size: 65,
                  color: Colors.grey,
                );
              },
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player["name"] == ""
                      ? "Unknown Player"
                      : player["name"],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                if (player["mvp"] == true)
                  const Text(
                    "MVP",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),

          Text(
            "${player["score"]}",
            style: const TextStyle(
              fontSize: 16,
            ),
          ),

          const SizedBox(width: 20),

          Text(
            "${player["kills"]} / "
            "${player["deaths"]} / "
            "${player["assists"]}",
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}