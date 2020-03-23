import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:khi_todo/dbhelper.dart';
import 'package:khi_todo/todo_model.dart';
import 'package:khi_todo/todolist.dart';
import 'package:provider/provider.dart';

class Todotile extends StatefulWidget {
  Todotile({Key key, this.item}) : super(key: key);
  Todos item;

  @override
  _TodotileState createState() => _TodotileState();
}

class _TodotileState extends State<Todotile> {
  TextEditingController _modycon;
  FocusNode myFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFocusNode = new FocusNode();
    _modycon = TextEditingController(text: widget.item.content);
    _modycon.addListener(checkNum);
  }

  void checkNum() {}
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
    if (widget.item.checked != 1) {
      if (modifier.getModify() == widget.item.id)
        return ListTile(
          leading: checkComple(),
          title: letsMody(),
        );
      else
        return ListTile(
            leading: checkComple(),
            title: justShow(),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                modifier.setModify(widget.item.id);
              },
            ));
    } else
      return ListTile(
        leading: checkComple(),
        title: Text(
          widget.item.content,
          style: TextStyle(
              decoration: TextDecoration.lineThrough, color: Colors.grey),
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

  Widget checkComple() {
    return Checkbox(
      value: checkreturn(widget.item),
      onChanged: (bool resp) {
        setState(() {
          checkList(widget.item, resp);
        });
      },
    );
  }

  Widget justShow() {
    return Text(widget.item.content);
  }

  Widget letsMody() {
    final modifier2 = Provider.of<Modify>(context);
    return Row(
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
                modifier2.setModify(0);
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
                modifier2.setModify(0);
              });
              DBHelper()
                  .updateTodos(widget.item.changeContent(_modycon.text.trim()));
            },
          ),
        )
      ],
    );
  }
}
