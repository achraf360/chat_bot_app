import 'package:chat_bot_app/chat.bot.page.dart';
import 'package:flutter/material.dart';

import 'home.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromARGB(500, 4, 76, 131),
        indicatorColor: Colors.white,
      ),
      routes: {
        "/chat": (context) => ChatBotPage(),
      },
      home: HomePage(),
    );
  }
}
