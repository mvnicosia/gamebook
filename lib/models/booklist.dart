import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'book.dart';

class BookList {

  final String filepath;
  final Map<String, Book> books;

  BookList(this.filepath, this.books);

  Future<File> _file() async {
    File file = File(filepath);
    bool fileExists = await file.exists();
    if (!fileExists) {
      return await file.create(recursive: true);
    }
    return Future.value(file); 
  }

  Future<File> _write() async { 
    File file = await _file(); 
    return await file.writeAsString(jsonEncode(books));
  }

  Future<BookList> add(Book book) async {
    books[book.filepath] = book;
    await _write();
    return Future.value(this);
  }

  Future<BookList> remove(Book book) async {
    books.remove(book.filepath);
    await _write();
    return Future.value(this); 
  }

  BookList.fromJson(Map<String, dynamic> content)
    : filepath = jsonDecode(content['filepath']),
      books = Map<String, Book>.from(jsonDecode(content['books']).map(
        (k, v) => MapEntry(k as String, Book.fromJson(v))));

  Map<String,dynamic> toJson() =>
    {
      'filepath': filepath,
      'books': jsonEncode(books),
    };

  @override
  String toString() => '{ filepath: $filepath, books: $books.toString() }';
}
