import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;

import 'package:path_provider/path_provider.dart';

class Book {

  static final RegExp titleRegex = RegExp(r"=+\n");

  final String title;
  final String filepath;

  Book(this.title, this.filepath);

  Future<String> read() async {
    File file = File(filepath);
    bool exists = await file.exists();
    if (exists) {
      return await file.readAsString();
    } else {
      return Future.value('File not found!');
    }
  }

  Book.fromJson(Map<String, dynamic> json)
    : title = json['title'],
      filepath = json['filepath'];

  Map<String, dynamic> toJson() =>
  {
    'title': title,
    'filepath': filepath,
  };

  static Future<Book> fromDefaultBooks(String name, String writePath) async {
    String content = await rootBundle.loadString('default_books/$name');
    String title = content.split(Book.titleRegex).first;
    File file = await File('$writePath/$name').writeAsString(content);
    return Future.value(Book(title, file.path));
  }

  @override
  String toString() => '{ title: $title, filepath: $filepath }';
}
