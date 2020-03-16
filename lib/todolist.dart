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
  List<Todos> todolist;

  @override
  void dispose() {
    super.dispose();
    _todoController.dispose();
  }

  @override
  void initState() {
    super.initState();
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
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '     ' +
                                    item.id.toString() +
                                    '         ' +
                                    item.content,
                                style: TextStyle(fontSize: 20),
                              ),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.mode_edit),
                                    onPressed: () {
                                      setState(() {});
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        DBHelper().deleteTodos(item.id);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
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
