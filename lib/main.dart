import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'models/book.dart';
import 'models/booklist.dart';

Future<void> main() async {
  runApp(GamebookApp());
}

class GamebookApp extends StatelessWidget {
  final String title = 'Gamebook';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$title',
      home: GamebookChooser(title: '$title: Chooser'),
    );
  }
}

class GamebookChooser extends StatefulWidget {

  final String title;

  GamebookChooser({Key key, this.title}) : super(key: key);

  @override
  _GamebookChooserState createState() => _GamebookChooserState();
}

class _GamebookChooserState extends State<GamebookChooser> {

  final List<String> defaultBooks = ['your_father_the_hero.md'];
  BookList bookList = BookList('',{});
  String selected = "";

  @override
  void initState() {
    super.initState();
    _loadBookList();
  }

  void _loadBookList() async {
    Directory dir = await getApplicationDocumentsDirectory();
    bookList = BookList('${dir.path}/booklist.json',{});
    for (final name in defaultBooks) {
      Book book = await Book.fromDefaultBooks(name, dir.path);
      BookList list = await bookList.add(book);
      setState(() {
        bookList = list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List books = List.from(bookList.books.entries);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              print(selected);
              setState(() {
                selected = books[index].key;
              });
              print(selected);
            },
            child: Card(
              child: Text(books[index].value.title),
            ),
          );
        }
      ),
    );
  }
}
