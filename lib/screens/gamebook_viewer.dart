import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

import '../models/book.dart';

class GamebookViewer extends StatefulWidget {

  final Book book;

  GamebookViewer({Key key, Book this.book}) : super(key: key);

  @override
  _GamebookViewerState createState() => _GamebookViewerState();
}

class _GamebookViewerState extends State<GamebookViewer> {

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: widget.book.read(),
      builder: (context, snapshot) => snapshot.hasData? 
        _buildWidget(widget.book.title, snapshot.data) : const SizedBox(),
  );

  Widget _buildWidget(String title, String content) {
    return Scaffold(
      appBar: AppBar(title: Text(title),),
      body: Markdown(data: content),
    );
  }
}
