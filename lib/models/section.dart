class Section {

  String anchor = "";
  String text = "";
  Map<String,String> choices = Map<String,String>();

  Section({String anchor, String text, Map<String,String> choices}) :
    this.anchor = anchor ?? "",
    this.text = text ?? "",
    this.choices = choices ?? Map<String,String>();

  @override
  String toString() {
    return '{ anchor: $anchor, text: $text, choices: $choices }';
  }
}
