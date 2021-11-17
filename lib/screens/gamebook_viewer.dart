import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

import '../models/book.dart';
import '../models/section.dart';

class GamebookViewer extends StatefulWidget {

  final Book book;

  GamebookViewer(Book this.book, {Key? key}) : super(key: key);

  @override
  _GamebookViewerState createState() => _GamebookViewerState();
}

class _GamebookViewerState extends State<GamebookViewer> {

  @override
  initState() {
    _loadBook();
    currentSection = bookMap['loading'];
    previousSection = null;
    super.initState();
  }

  Map<String,Section> bookMap = {
    'loading': Section('', 'Loading...', {}),
    'error': Section('', 'There was an error loading the book.', {}),
  };
  Section? currentSection;
  Section? previousSection;

  Future<void> _loadBook() async {
    Map<String,Section> bookMap = await widget.book.read();
    setState(() {
      this.bookMap.addAll(bookMap);
      currentSection = bookMap['start'];
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> choices = currentSection?.choices.keys.toList() ?? [];
    var undo = null;
    if (previousSection != currentSection) {
      undo = () {
        setState(() {
            currentSection = previousSection;
        });
      };
    }
    return Scaffold(
      appBar: AppBar(title: Text(widget.book.title)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 16,
            child: ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment(0.0, 0.9),
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.transparent],
                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
              },
              blendMode: BlendMode.dstIn,
              child: Markdown(
                data: currentSection?.text ?? '',
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                    blockquote: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: IconButton(
                        icon: Icon(Icons.undo),
                        onPressed: undo,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: ListView.builder(
                    itemCount: choices.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            previousSection = currentSection;
                            currentSection = bookMap[currentSection?.choices[choices[index]] ?? 'error'];
                          });
                        },
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(choices[index]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
