import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:khi_todo/dbhelper.dart';
import 'package:khi_todo/todo_model.dart';
import 'package:khi_todo/todolist.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class Todotile extends StatefulWidget {
  Todotile({Key key, this.item, this.canMody}) : super(key: key);
  Todos item;
  int canMody;

  @override
  _TodotileState createState() => _TodotileState();
}

class _TodotileState extends State<Todotile> {
  bool mody;
  TextEditingController _modycon;
  FocusNode myFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mody = false;
    myFocusNode = new FocusNode();
    _modycon = TextEditingController(text: widget.item.content);
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
    debugPrint('Tile build!');

    final modifier = Provider.of<Modify>(context);
    return ListTile(
      leading: Checkbox(
        value: checkreturn(widget.item),
        onChanged: (bool resp) {
          setState(() {
            checkList(widget.item, resp);
          });
        },
      ),
//      trailing: IconButton(
//        icon: Icon(Icons.edit),
//        color: Colors.blue,
//        onPressed: () {
//          setState(() {
//            widget.canMody = widget.item.id;
//            if (widget.canMody == widget.item.id) mody = true;
//          });
//        },
//      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (modifier.getModify() == widget.item.id)
            Row(
              children: <Widget>[
                Container(
                  width: 150,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    controller: _modycon,
                    autofocus: true,
                    focusNode: myFocusNode,
                    onSubmitted: (String value) {
                      Todos temp = widget.item;
                      temp.content = _modycon.text.trim();
                      DBHelper().updateTodos(temp);
                      setState(() {
                        mody = false;
                      });
                      debugPrint(value);
                    },
                    textInputAction: TextInputAction.done,
                  ),
                ),
                Container(
                  width: 50,
                  child: FlatButton(
                    child: Text('저장'),
                    onPressed: () {
                      setState(() {
                        mody = false;
                        modifier.setModify(0);
                      });
                      DBHelper().updateTodos(
                          widget.item.changeContent(_modycon.text.trim()));
                    },
                  ),
                )
              ],
            )
          else if (widget.item.checked == 1)
            Container(
              width: 150,
              child: FlatButton(
                child: Text(
                  widget.item.content,
                  style: TextStyle(
                    fontSize: 20,
                    decoration: TextDecoration.lineThrough,
                  ),
                  overflow: TextOverflow.visible,
                ),
              ),
            )
          else
            FlatButton(
              child: Text(
                widget.item.content,
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                setState(() {
                  mody = true;
                  modifier.setModify(widget.item.id);
                });
                myFocusNode.requestFocus();
              },
            ),
//          IconButton(
//            icon: Icon(Icons.mode_edit),
//            onPressed: () {
//              myFocusNode.requestFocus();
//              if (mody) {
//                if (_formkey.currentState.validate()) {
//                  Todos temp = widget.item;
//                  temp.content = _modycon.text.trim();
//                  DBHelper().updateTodos(temp);
//                  setState(() {
//                    mody = false;
//                  });
//                }
//              } else {
//                setState(() {
//                  mody = true;
//                });
//              }
////                myFocusNode.requestFocus();
//            },
//          ),
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
