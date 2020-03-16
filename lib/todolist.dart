import 'package:flutter/material.dart';
import 'package:khi_todo/dbhelper.dart';
import 'package:khi_todo/todo_model.dart';

class myTodolist extends StatefulWidget {
  @override
  _myTodolistState createState() => _myTodolistState();
}

class _myTodolistState extends State<myTodolist> {
  final _formkey = GlobalKey<FormState>();
  final _todoController = TextEditingController();
  final _modyController = TextEditingController();

  //List<Todos> todolist;

  @override
  void dispose() {
    super.dispose();
    _todoController.dispose();
    _modyController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void deleteSomeList(int id) {
    setState(() {
      DBHelper().deleteTodos(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Form(
              key: _formkey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Todo: "),
                  Container(
                    width: 200,
                    child: TextFormField(
                      controller: _todoController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'type your todo list',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return '할 일을 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                  ),
                  RaisedButton(
                    child: Text('저장'),
                    onPressed: () {
                      setState(() {
                        debugPrint(_todoController.text.trim());
                        var res =
                            DBHelper().createData(_todoController.text.trim());
                        DBHelper().getTodos(1);
                        _todoController.clear();
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Divider(
              height: 2,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),
                ),
                Text(
                  'Todays List',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      DBHelper().deleteAllTodos();
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder(
                future: DBHelper().getAllTodos(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Todos>> snapshot) {
                  if (snapshot.hasData) {
                    debugPrint('snapshot has data');
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Todos item = snapshot.data[index];
                        return ListTile(
                          leading: Text(item.id.toString()),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            focusColor: Colors.blueGrey,
                            onPressed: () {
                              setState(() {
                                DBHelper().deleteTodos(item.id);
                              });
                            },
                          ),
                          title: Todotile(
                            item: item,
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mody = false;
    checked = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _modycon.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
            setState(() {
              if (mody) {
                mody = false;
                Todos temp = widget.item;
                temp.content = _modycon.text.trim();
                DBHelper().updateTodos(temp);
              } else
                mody = true;
            });
          },
        ),
      ],
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
