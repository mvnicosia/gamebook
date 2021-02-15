import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;

import 'package:path_provider/path_provider.dart';

import 'section.dart';

class Book {

  static final RegExp anyHeadingRegex = RegExp(r"^\s{0,3}#{1,6}");

  final String title;
  final String filepath;

  Map<String,Section> bookMap = Map<String,Section>();

  Book(this.title, this.filepath);

  Future<Map<String,Section>> read() async {
    if (bookMap.isNotEmpty) {
      return Future.value(bookMap);
    }
    File file = File(filepath);
    bool exists = await file.exists();
    if (exists) {
      return await _parseBook(file);
    } else {
      bookMap['start'] = Section(text: 'File not found!');
      return Future.value(bookMap);
    }
  }

  Future<Map<String,Section>> _parseBook(File file) async {
    List<String> lines = await file.readAsLines();
    List<Section> sections = List<Section>();
    for (int i=0; i<lines.length; i++) {
      Section section = Section();      
      if (anyHeadingRegex.hasMatch(lines[i])) {
        section.text = lines[i];
        section.anchor = anchorReference(lines[i]);
        while (i<lines.length-1 && !anyHeadingRegex.hasMatch(lines[i+1])) {
          i = i+1;
          section.text = '${section.text}\n${lines[i]}';
        }
      } else {
        continue;
      }
      sections.add(section);
    }
    for (int i=0; i<sections.length-1; i++) {
      if (sections[i].choices.isEmpty) {
        sections[i].choices['Continue...'] = sections[i+1].anchor;
      }
      if (i == 0) {
        bookMap['start'] = sections[i];
      } else {
        bookMap[sections[i].anchor] = sections[i]; 
      }
    }
    return Future.value(bookMap);
  }

  static String anchorReference(String heading) {
    return '#' + heading.split(anyHeadingRegex).
      last.
      trim().
      replaceAll(" ", "-").
      replaceAll(RegExp(r"[^a-zA-Z0-9\-]"), "").
      toLowerCase();
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
    // TODO: figure out another way to parse the title and remove from here 
    String title = content.split("\n").first.split("#").last.trim();
    File file = await File('$writePath/$name').writeAsString(content);
    return Future.value(Book(title, file.path));
  }

  @override
  String toString() => '{ title: $title, filepath: $filepath }';
}
