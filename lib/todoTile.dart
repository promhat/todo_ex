import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:khi_todo/dbhelper.dart';
import 'package:khi_todo/todo_model.dart';
import 'package:khi_todo/todolist.dart';
import 'package:provider/provider.dart';

class Todotile extends StatefulWidget {
  Todotile({Key key, this.item, this.delMode}) : super(key: key);
  Todos item;
  bool delMode;

  @override
  _TodotileState createState() => _TodotileState();
}

class _TodotileState extends State<Todotile> {
  TextEditingController _modycon;
  FocusNode myFocusNode;
  bool deldel;

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

  bool checkdel() {
    if (widget.item.delkey == 1)
      return true;
    else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Tile build!');

    debugPrint(widget.item.tomap().toString());
    if (widget.delMode)
      return ListTile(
        leading: Theme(
          data: ThemeData(
            unselectedWidgetColor: Colors.amber,
          ),
          child: Checkbox(
            value: checkdel(),
            activeColor: Colors.amber,
            onChanged: (bool del) {
              Todos temp = widget.item;
              setState(() {});
              if (del)
                temp.delkey = 1;
              else
                temp.delkey = 0;
              DBHelper().updateTodos(temp);
            },
          ),
        ),
        title: justShow(),
      );
    else
      return TodoMode();
  }

  Widget TodoMode() {
    final modifier = Provider.of<Modify>(context);
    if (widget.item.checked != 1) {
      if (modifier.getModify() == widget.item.id)
        return ListTile(
          leading: checkComple(),
          title: letsMody(),
        );
      else {
        return ListTile(
            leading: checkComple(),
            title: justShow(),
            trailing: Wrap(spacing: 2, children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                color: Colors.black,
                onPressed: () {
                  modifier.setModify(widget.item.id);
                },
              ),
//              IconButton(
//                icon: Icon(Icons.clear),
//                color: Colors.amber,
//                onPressed: () {
//                  setState(() {
//                    DBHelper().deleteTodos(widget.item.id);
//                  });
//                },
//              ),
            ]));
      }
    } else
      return ListTile(
        leading: checkComple(),
        title: Text(
          //showComple()
          widget.item.content,
          style: TextStyle(
              decoration: TextDecoration.lineThrough,
              fontStyle: FontStyle.italic,
              color: Colors.amber),
        ),
//        trailing: IconButton(
//          icon: Icon(Icons.clear),
//          color: Colors.amber,
//          onPressed: () {
//            setState(() {
//              DBHelper().deleteTodos(widget.item.id);
//            });
//          },
//        ),
      );
  }

  checkList(Todos todo, bool check) {
    if (check)
      todo.checked = 1;
    else
      todo.checked = 0;
    DBHelper().updateTodos(todo);
  }

  Widget checkComple() {
//    return Checkbox(
//      value: checkreturn(widget.item),
//      onChanged: (bool resp) {
//        setState(() {
//          checkList(widget.item, resp);
//        });
//      },
//    );
    if (widget.item.checked == 1)
      return IconButton(
        icon: Icon(Icons.favorite),
        color: Colors.amber,
        onPressed: () {
          setState(() {
            checkList(widget.item, false);
          });
        },
      );
    else
      return IconButton(
        icon: Icon(Icons.favorite_border),
        color: Colors.amber,
        onPressed: () {
          setState(() {
            checkList(widget.item, true);
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
          width: 200,
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
          width: 100,
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
