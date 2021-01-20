import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String title = 'Gamebook';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$title',
      home: MyHomePage(title: '$title: Chooser'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Directory appDocsDir;
  String appDocsDirPath;

  final List<String> defaultBooks = ['your_father_the_hero.md'];

  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  void writeDefaultBooks(String path) {
    Future<String> defaultBookContent;
    for (final name in defaultBooks) {
      defaultBookContent = getFileData('default_books/$name');
      defaultBookContent.then((content) {
        final file = new File('$path/$name');
        file.writeAsString('$content');
      });
    }
  }

  @override
  void initState() {
    getApplicationDocumentsDirectory().then((dir) {
      appDocsDir = dir;
      appDocsDirPath = dir.path;
      writeDefaultBooks(appDocsDirPath);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Text('Here be dragons...'),
          ],
        ),
      ),
    );
  }
}
