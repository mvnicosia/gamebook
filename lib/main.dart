import 'package:flutter/material.dart';

import 'screens/gamebook_chooser.dart';

void main() => runApp(GamebookApp());

class GamebookApp extends StatelessWidget {
  final String title = 'Gamebook';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$title',
      home: GamebookChooser(appTitle: title),
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
    );
  }
}

