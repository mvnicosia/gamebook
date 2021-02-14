import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

import '../models/book.dart';
import '../models/section.dart';

class GamebookViewer extends StatefulWidget {

  final Book book;

  GamebookViewer({Key key, Book this.book}) : super(key: key);

  @override
  _GamebookViewerState createState() => _GamebookViewerState();
}

class _GamebookViewerState extends State<GamebookViewer> {

  Map<String,Section> bookMap = {'start': Section(text: 'Loading...')};
  String currentSection = 'start';

  Future<void> _loadBook() async {
    Map<String,Section> bookMap = await widget.book.read();
    setState(() {
      this.bookMap = bookMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadBook();
    return Scaffold(
      appBar: AppBar(title: Text(widget.book.title)),
      body: Markdown(data: bookMap[currentSection].text),
    );
  } 
}
