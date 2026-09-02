import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SocialPage());
  }
}

class Friend {
  String name;
  String status;
  String game;
  bool valorant;
  Color color;

  Friend(this.name, this.status, this.game, this.valorant, this.color);
}

class SocialPage extends StatelessWidget {
  SocialPage({super.key});

  final String title = "Social";
  final String search = "Search";

  final List<Friend> friends = [
    Friend("MissYouLikeKrazy", "Online", "VALORANT", true, Colors.green),
    Friend("bread", "Playing", "VALORANT", true, Colors.cyan),
    Friend("The14th", "Playing", "VALORANT", true, Colors.cyan),
  ];

  final List<Friend> online = [
    Friend("Carlvendish", "Away", "Riot Mobile", false, Colors.amber),
    Friend("D1yah", "Away", "Riot Mobile", false, Colors.amber),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff120e0f),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 7),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(
              height: 43,
              child: Row(
                children: [
                  const SizedBox(width: 23),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "Friends",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 11),

                      Container(
                        width: 34,
                        height: 2,
                        color: const Color(0xffff4655),
                      ),
                    ],
                  ),

                  const SizedBox(width: 32),

                  const Padding(
                    padding: EdgeInsets.only(bottom: 11),
                    child: Text(
                      "Messages",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),

                  const SizedBox(width: 32),

                  const Padding(
                    padding: EdgeInsets.only(bottom: 11),
                    child: Text(
                      "Requests",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            Container(height: 1, color: const Color(0xff292526)),

            Padding(
              padding: const EdgeInsets.fromLTRB(15, 16, 14, 15),
              child: Card(
                color: const Color(0xff242021),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                child: SizedBox(
                  height: 46,
                  child: Row(
                    children: [
                      const SizedBox(width: 14),

                      const Icon(Icons.search, color: Colors.grey, size: 25),

                      const SizedBox(width: 8),

                      Text(
                        search,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(left: 27, right: 15),
                children: [
                  Row(
                    children: [
                      const Text(
                        "VALORANT",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 7),

                      const Text(
                        "3",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),

                  const SizedBox(height: 13),

                  for (var f in friends) showFriend(f),

                  const SizedBox(height: 4),

                  const Row(
                    children: [
                      Text(
                        "Online",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(width: 7),

                      Text(
                        "4",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),

                  const SizedBox(height: 13),

                  for (var f in online) showFriend(f),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showFriend(Friend f) {
    String name = f.name.isEmpty ? "Unknown" : f.name;
    String status = f.status.isEmpty ? "Unknown" : f.status;
    String game = f.game.isEmpty ? "No game" : f.game;

    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: Color(0xff282425),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: 27,
                  color: f.valorant ? const Color(0xffff4655) : Colors.white,
                ),
              ),

              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: f.color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xff120e0f),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 3),

                Row(
                  children: [
                    Icon(
                      f.valorant ? Icons.desktop_windows : Icons.phone_android,
                      color: Colors.grey,
                      size: 15,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      status,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),

                    const Text(
                      " - ",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),

                    Flexible(
                      child: Text(
                        game,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
