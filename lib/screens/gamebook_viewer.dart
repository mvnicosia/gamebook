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

  Map<String,Section> bookMap = {
    'start': Section(text: 'Loading...'),
    'error': Section(text: 'There was an error loading the book.'),
  };
  String currentSection = 'start';

  Future<void> _loadBook() async {
    Map<String,Section> bookMap = await widget.book.read();
    setState(() {
      this.bookMap.addAll(bookMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadBook();
    List<String> choices = List.from(bookMap[currentSection].choices.keys);
    return Scaffold(
      appBar: AppBar(title: Text(widget.book.title)),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Markdown(data: bookMap[currentSection].text),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: choices.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (bookMap.containsKey(choices[index])) {
                      setState(() {
                        currentSection = choices[index];
                      });
                    } else {
                      setState(() {
                        currentSection = 'error';
                      });
                    }
                  },
                  child: Card(
                    child: Text(choices[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  } 
}
