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

  File bookList;
  final RegExp bookTitleRegex = RegExp(r"=+\n");

  final List<String> defaultBooks = ['your_father_the_hero.md'];

  List<File> books;

  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  void registerDefaultBooks() {
    Future<String> defaultBookContent;
    for (final name in defaultBooks) {
      String path = 'default_books/$name';
      defaultBookContent = getFileData(path);
      defaultBookContent.then((content) {
        String title = content.split(bookTitleRegex).first;
        print('$path|$title');
        bookList.writeAsStringSync('$path|$title',
            mode: FileMode.append, flush: true);
      });
    }
  }

  @override
  void initState() {
    getApplicationDocumentsDirectory().then((dir) {
      appDocsDir = dir;
      appDocsDirPath = dir.path;
      bookList = File('$appDocsDirPath/bookList');
      bookList.exists().then((notFirstTime) {
        if (notFirstTime) {
          // do nothing
          bookList.readAsString().then((f) => print(f));
        } else {
          bookList.create();
          registerDefaultBooks();
        }
      });
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
