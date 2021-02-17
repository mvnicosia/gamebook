import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../models/book.dart';
import '../models/booklist.dart';

import '../screens/gamebook_viewer.dart';

class GamebookChooser extends StatefulWidget {

  final String title;

  GamebookChooser({Key key, String appTitle}) :
    title = '$appTitle: Chooser',
    super(key: key);

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
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => GamebookViewer(book: books[index].value),
                ),
              );
            },
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: Row(
                  children: <Widget> [
                    Expanded(
                      flex: 1,
                      child: Icon(Icons.book),
                    ),
                    Expanded(
                      flex: 9,
                      child: Text(books[index].value.title),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
