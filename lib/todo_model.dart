class Todos {
  int id;
  String content;
  int checked;

  Todos({this.id, this.content, this.checked});

  Todos fromMap(Map<String, dynamic> map) {
    this.id = map[id];
    this.content = map[content];
    this.checked = map[checked];
  }

  Map<String, dynamic> tomap() {
    return {'id': id, 'content': content, 'checked': checked};
  }
}
