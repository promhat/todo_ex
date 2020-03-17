import 'package:flutter/material.dart';
import 'package:khi_todo/dbhelper.dart';
import 'package:khi_todo/todo_model.dart';

class Todotile extends StatefulWidget {
  Todotile({Key key, this.item}) : super(key: key);
  Todos item;

  @override
  _TodotileState createState() => _TodotileState();
}

class _TodotileState extends State<Todotile> {
  bool mody;
  final _modycon = TextEditingController();
  bool checked;
  final _formkey = GlobalKey<FormState>();
  FocusNode myFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mody = false;
    checked = false;
    myFocusNode = new FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _modycon.dispose();
    myFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build!');
    return Form(
      key: _formkey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Checkbox(
            value: checkreturn(widget.item),
            onChanged: (bool resp) {
              setState(() {
                checked = resp;
                checkList(widget.item, checked);
              });
            },
          ),
          if (mody == true)
            Container(
              width: 100,
              child: TextFormField(
                controller: _modycon,
//                autofocus: true,
                focusNode: myFocusNode,
                onFieldSubmitted: (String value) {
                  Todos temp = widget.item;
                  temp.content = _modycon.text.trim();
                  DBHelper().updateTodos(temp);
                  setState(() {
                    mody = false;
                  });
                  debugPrint(value);
                },
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value.isEmpty) {
                    return '수정내용을 입력하세요.';
                  }
                  return null;
                },
              ),
            )
          else if (mody == false)
            if (widget.item.checked == 1)
              Container(
                child: Text(
                  widget.item.content,
                  style: TextStyle(
                    fontSize: 20,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              )
            else
              Container(
                child: Text(
                  widget.item.content,
                  style: TextStyle(fontSize: 20),
                ),
              ),
          IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: () {
              myFocusNode.requestFocus();
              if (mody) {
                if (_formkey.currentState.validate()) {
                  Todos temp = widget.item;
                  temp.content = _modycon.text.trim();
                  DBHelper().updateTodos(temp);
                  setState(() {
                    mody = false;
                  });
                }
              } else {
                setState(() {
                  mody = true;
                });
              }
//                myFocusNode.requestFocus();
            },
          ),
        ],
      ),
    );
  }

  bool checkreturn(Todos todos) {
    if (todos.checked == 1)
      return true;
    else
      return false;
  }

  checkList(Todos todo, bool check) {
    if (check)
      todo.checked = 1;
    else
      todo.checked = 0;
    DBHelper().updateTodos(todo);
  }
}
