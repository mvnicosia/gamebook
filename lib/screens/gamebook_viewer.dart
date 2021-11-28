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
    currentSection = widget.book.currentSection;
    previousSection = widget.book.previousSection;
    super.initState();
  }

  Section? currentSection = null;
  Section? previousSection = null;

  Future<void> _loadBook() async {
    await widget.book.read();
    setState(() {
      currentSection = widget.book.currentSection;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> choices = widget.book.currentChoices();
    var undo = null;
    if (previousSection != currentSection) {
      undo = () {
        setState(() {
            currentSection = widget.book.setSection(previousSection);
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
                            currentSection = widget.book.followChoice(choices[index]);
                            previousSection = widget.book.previousSection;
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
