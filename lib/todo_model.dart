class Todos {
  int id;
  String content;
  int checked;
  int delkey;

  Todos({this.id, this.content, this.checked, this.delkey});

  Todos fromMap(Map<String, dynamic> map) {
    this.id = map[id];
    this.content = map[content];
    this.checked = map[checked];

    this.delkey = map[delkey];
  }

  Todos changeContent(String con) {
    this.content = con;
    return this;
  }

  Map<String, dynamic> tomap() {
    return {'id': id, 'content': content, 'checked': checked, 'delkey': delkey};
  }
}
