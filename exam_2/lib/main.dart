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
      home: const SocialPage(),
    );
  }
}

class Friend {
  String? name;
  String? status;
  String? game;
  bool? valorant;
  bool? online;
  Color? color;

  Friend(
    this.name,
    this.status,
    this.game,
    this.valorant,
    this.online,
    this.color,
  );
}

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  final String? title = "Social";
  final String? search = "Search";

  final List<Friend> friends = [
    Friend(
      "MissYouLikeKrazy",
      "Online",
      "VALORANT",
      true,
      true,
      Colors.green,
    ),
    Friend(
      "bread",
      "Playing",
      "VALORANT",
      true,
      true,
      Colors.cyan,
    ),
    Friend(
      "The14th",
      "Playing",
      "VALORANT",
      true,
      false,
      Colors.cyan,
    ),
    Friend(
      "Carlvendish",
      "Away",
      "Riot Mobile",
      false,
      false,
      Colors.amber,
    ),
    Friend(
      "D1yah",
      "Away",
      "Riot Mobile",
      false,
      false,
      Colors.amber,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    String displayTitle = title ?? "Social";
    String displaySearch = search ?? "Search";

    return Scaffold(
      backgroundColor: const Color(0xff120e0f),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 7),
              child: Text(
                displayTitle,
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
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(width: 32),

                  const Padding(
                    padding: EdgeInsets.only(bottom: 11),
                    child: Text(
                      "Requests",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 1,
              color: const Color(0xff292526),
            ),

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

                      const Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 25,
                      ),

                      const SizedBox(width: 8),

                      Text(
                        displaySearch,
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
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 27, right: 15),
                itemCount: friends.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 13),
                      child: Row(
                        children: [
                          Text(
                            "VALORANT",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(width: 7),

                          Text(
                            "3",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (index == 4) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 2, bottom: 13),
                      child: Row(
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
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  int friendIndex;

                  if (index < 4) {
                    friendIndex = index - 1;
                  } else {
                    friendIndex = index - 2;
                  }

                  return showFriend(friends[friendIndex]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showFriend(Friend f) {
    String name = f.name ?? "Unknown User";
    String status = f.status ?? "Unknown";
    String game = f.game ?? "No game available.";
    bool valorant = f.valorant ?? false;
    bool online = f.online ?? false;
    Color color = f.color ?? Colors.grey;

    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatRoomScreen(
                friend: f,
              ),
            ),
          );
        },

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
                    color: valorant
                        ? const Color(0xffff4655)
                        : Colors.white,
                  ),
                ),

                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: online ? color : Colors.grey,
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 3),

                  Row(
                    children: [
                      Icon(
                        valorant
                            ? Icons.desktop_windows
                            : Icons.phone_android,
                        color: Colors.grey,
                        size: 15,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        status,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),

                      const Text(
                        " - ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
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
      ),
    );
  }
}

class ChatRoomScreen extends StatefulWidget {
  final Friend friend;

  const ChatRoomScreen({
    super.key,
    required this.friend,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController messageController =
      TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.friend.name ?? "Unknown User";
    String game = widget.friend.game ?? "No game available.";
    bool online = widget.friend.online ?? false;

    return Scaffold(
      backgroundColor: const Color(0xff120e0f),

      appBar: AppBar(
        backgroundColor: const Color(0xff120e0f),
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        titleSpacing: 0,

        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xff282425),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 19,
              ),
            ),

            const SizedBox(width: 9),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  online
                      ? "Online - $game"
                      : "Away - $game",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("More options"),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: Container(),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                12,
                6,
                12,
                10,
              ),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xff242021),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Send a message",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                        ),
                      ),
                    ),

                    IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.grey,
                        size: 18,
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}