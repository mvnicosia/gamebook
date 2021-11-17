class Section {

  final String anchor;
  final String text;
  final Map<String,String> choices;

  Section(String this.anchor, String this.text, Map<String,String> this.choices);

  @override
  String toString() {
    return '{ anchor: $anchor, text: $text, choices: $choices }';
  }
}
