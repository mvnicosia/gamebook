import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;

import 'section.dart';

class Book {

  static final RegExp anyHeadingRegex = RegExp(r"^\s{0,3}#{1,6}");
  static final RegExp choicesRegex = RegExp(r"^_CHOICES:_");
  static final RegExp endRegex = RegExp(r"^_The End_");
  static final RegExp ulRegex = RegExp(r"^[*-+]\s");
  static final RegExp choiceLinkRegex = RegExp(
      r"\[(?<linkText>[^\[\]]+)\]\((?<anchorText>#[\w\-]+)\)");

  final String title;
  final String filepath;

  Map<String,Section> map = {
    'loading': Section('', 'Loading...', {}),
    'error': Section('', 'There was an error loading the book.', {}),
  };

  Section? currentSection;
  Section? previousSection = null;

  Book(this.title, this.filepath) {
    currentSection = map['loading'];
  }

  Future<void> read() async {
    File file = File(filepath);
    bool exists = await file.exists();
    if (exists) {
      await _parseBook(file);
      currentSection = map['start'];
    } else {
      currentSection = map['error'];
    }
  }

  Future<void> _parseBook(File file) async {
    List<String> lines = await file.readAsLines();
    List<Section> sections = [];
    for (int i=0; i<lines.length; i++) {
      String text = lines[i];
      String anchor = anchorReference(text);
      Map<String,String> choices = {};
      bool isTheEnd = false;
      if (anyHeadingRegex.hasMatch(text)) {
        while (i<lines.length-1 && !anyHeadingRegex.hasMatch(lines[i+1])) {
          i = i+1;
          if (choicesRegex.hasMatch(lines[i])) {
            while(i<lines.length-1 &&
                !anyHeadingRegex.hasMatch(lines[i+1]) &&
                ulRegex.hasMatch(lines[i+1])) {
              i = i+1;
              String line = lines[i].split(ulRegex).last.trim();
              RegExpMatch? match = choiceLinkRegex.firstMatch(line);
              if (match != null) {
                String? linkText = match.namedGroup('linkText');
                String? anchorText = match.namedGroup('anchorText');
                if (linkText != null && anchorText != null) {
                  choices[linkText] = anchorText;
                }
              }
            }
          } else if (endRegex.hasMatch(lines[i])) {
            isTheEnd = true;
          } else {
            text = '${text}\n${lines[i]}';
          }
        }
      } else {
        continue;
      }
      sections.add(Section(anchor, text, choices, isTheEnd: isTheEnd));
    }
    for (int i=0; i<sections.length-1; i++) {
      Section thisSection = sections[i];
      Section nextSection = sections[i+1];
      if (thisSection.choices.isEmpty && !thisSection.isTheEnd) {
        thisSection.choices['Continue...'] = nextSection.anchor;
      }
      if (i == 0) {
        map['start'] = thisSection;
      } else {
        map[thisSection.anchor] = thisSection; 
      }
    }
    map[sections.last.anchor] = sections.last;
  }

  static String anchorReference(String heading) {
    return '#' + heading.split(anyHeadingRegex).
      last.
      trim().
      replaceAll(" ", "-").
      replaceAll(RegExp(r"[^a-zA-Z0-9\-]"), "").
      toLowerCase();
  }

  Section? setSection(Section? section) {
    previousSection = currentSection;
    currentSection = section;
    return currentSection;
  }

  Section? followChoice(String key) {
    previousSection = currentSection;
    currentSection = map[currentSection?.choices[key] ?? 'error'];
    return currentSection;
  }

  List<String> currentChoices() => currentSection?.choices.keys.toList() ?? [];

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
