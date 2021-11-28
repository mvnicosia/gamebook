class Section {

  final String anchor;
  final String text;
  final Map<String,String> choices;
  final bool isTheEnd;

  Section(String this.anchor,
          String this.text,
          Map<String,String> this.choices,
          {bool? isTheEnd}): this.isTheEnd = isTheEnd ?? false;

  @override
  String toString() {
    return '{ anchor: $anchor, text: $text, choices: $choices, isTheEnd: $isTheEnd }';
  }
}
