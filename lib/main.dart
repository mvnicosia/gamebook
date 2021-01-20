import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final String _title = 'Gamebook';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$_title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: '$_title: Chooser'),
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

  Future<Directory> _appDocumentsDirectory;

  List<String> defaultBooks = ['Your_Father_The_Hero.md']; 

  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  @override
  void initState() {
    String appDocsDir; 
    _appDocumentsDirectory = getApplicationDocumentsDirectory();
    _appDocumentsDirectory.then((dir) {
        appDocsDir = dir.path;
    });

    Future<String> _defaultBookContent;
    for (final name in defaultBooks) {
      _defaultBookContent = getFileData('default_books/$name');
      _defaultBookContent.then((content) {
        final file = new File('$appDocsDir/$name');
        file.writeAsString('$content');
      });
    }

    _appDocumentsDirectory.then(
      (dir) => dir.list().listen(
        (f) => print(f)));
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Here be dragons...'),
            ),
          ],
        ),
      ),
    );
  }
}

