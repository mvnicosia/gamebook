import 'package:flutter/material.dart';

class GamebookHomePage extends StatefulWidget {
  const GamebookHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<GamebookHomePage> createState() => _GamebookHomePageState();
}

class _GamebookHomePageState extends State<GamebookHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to Gamebook.',
            ),
          ],
        ),
      ),
    );
  }
}
