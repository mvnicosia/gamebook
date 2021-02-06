import 'package:flutter/material.dart';

import '../models/book.dart';

class GamebookViewer extends StatefulWidget {

  final Book book;

  GamebookViewer({Key key, Book this.book}) : super(key: key);

  @override
  _GamebookViewerState createState() => _GamebookViewerState();
}

class _GamebookViewerState extends State<GamebookViewer> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.book.title),),
      body: Text(widget.book.filepath),
    );
  }
}
