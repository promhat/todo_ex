import 'package:flutter/material.dart';
import 'package:khi_todo/dbhelper.dart';
import 'package:khi_todo/todoTile.dart';
import 'package:khi_todo/todo_model.dart';
import 'package:provider/provider.dart';

class myTodolist extends StatefulWidget {
  @override
  _myTodolistState createState() => _myTodolistState();
}

// 수정 모드에 있는 리스트 컬럼(데이터베이스) 아이디.
class Modify with ChangeNotifier {
  int _mody;
  Modify(this._mody);
  getModify() => _mody;
//  setModify(int mody) => _mody = mody;
  setModify(int mody) {
    _mody = mody;
    notifyListeners();
    debugPrint('setModify ' + _mody.toString());
  }
}

class SelectDel with ChangeNotifier {
  var delList = [];
  SelectDel(this.delList);

  addDelList(int del) {
    if (delList.contains(del)) {
    } else
      delList.add(del);
    debugPrint('delList : ' + delList.toString());
  }

  cancleDel(int del) {
    delList.remove(del);
    debugPrint('delList : ' + delList.toString());
  }

  DeleteList() {
    for (int i = 0; i < delList.length; i++)
      DBHelper().deleteTodos(delList.indexOf(i));
    notifyListeners();
    delList.clear();
  }
}

class _myTodolistState extends State<myTodolist> {
  final _formkey = GlobalKey<FormState>();
  final _todoController = TextEditingController();
  bool _addTodo;
  bool _delMode;
  bool _delAll;
  FocusNode myFocusNode;

  @override
  void dispose() {
    super.dispose();
    _todoController.dispose();
    myFocusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    _addTodo = false;
    _delMode = false;
    _delAll = false;
  }

  void deleteSomeList(int id) {
    setState(() {
      DBHelper().deleteTodos(id);
    });
  }

  // 빌드
  @override
  Widget build(BuildContext context) {
    //프로바이더 사용, 현재 컨텍스트 값을 자식에서 사용하고 변화를 관찰.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Modify>(create: (_) => Modify(0)),
        ChangeNotifierProvider<SelectDel>(
          create: (_) => SelectDel([]),
        )
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'TODO LIST',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            trailingMode(),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              // 할 일 추가 텍스트폼 (선택적 출력)
              addTodo(),
              AllDelCheck(),
              // DB 리스트 조회 및 출력
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
                          return Todotile(
                            item: item,
                            delMode: _delMode,
                          );
                        },
                      );
                    } else {
                      // 리스트 뷰에 표시할 데이터가 없을 경우 원 모양 인디케이터를 표
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              // Add Mode Toggle Button
              // Click 시 전체 화면을 Add Mode로 다시 렌더
            ],
          ),
        ),
        floatingActionButton: Wrap(
          children: <Widget>[
            if (_delMode)
              SizedBox(
                width: 5,
              )
            else
              floatingMode(),
          ],
        ),
      ),
    );
  }

  Widget AllDelCheck() {
    if (_delMode)
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Checkbox(
                value: _delAll,
                onChanged: (bool all) {
                  setState(() {
                    _delAll = all;
                  });
                }),
          ),
          Container(
            child: RaisedButton(
              child: Text('삭제하기'),
              color: Colors.amber,
              onPressed: () {},
            ),
          ),
        ],
      );
    else
      return SizedBox(
        height: 2,
      );
  }

  Widget trailingMode() {
    if (_delMode)
      return Wrap(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (_delMode)
                setState(() {
                  _delMode = false;
                });
              else
                setState(() {
                  _delMode = true;
                });
            },
          ),
        ],
      );
    else
      return Wrap(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (_delMode)
                setState(() {
                  _delMode = false;
                });
              else
                setState(() {
                  _delMode = true;
                });
            },
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
      );
  }

  Widget floatingMode() {
    if (_addTodo)
      return FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          setState(() {
            _addTodo = false;
          });
          _todoController.clear();
          FocusScope.of(context).requestFocus();
        },
        tooltip: '입력 취소',
        child: Icon(Icons.clear),
      );
    else
      return FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          setState(() {
            _addTodo = true;
          });
          FocusScope.of(context).requestFocus();
        },
        tooltip: '할 일 추가',
        child: Icon(Icons.add),
      );
  }

  void addTodolist() {
    if (_formkey.currentState.validate()) {
      debugPrint(_todoController.text.trim());
      var res = DBHelper().createData(_todoController.text.trim());
      DBHelper().getTodos(1);
      setState(() {
        _todoController.clear();
        _addTodo = false;
      });
    }
  }

  Widget addTodo() {
    if (_addTodo) {
      return Column(
        children: <Widget>[
          SizedBox(
            height: 20,
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
                    autofocus: true,
                    focusNode: myFocusNode,
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
                    onEditingComplete: () => addTodolist(),
                  ),
                ),
                // 저장버튼
                // 폼 Validator 활용, 입력값이 없을 경우 처리 X
                RaisedButton(
                  child: Text('저장'),
                  color: Colors.amber,
                  onPressed: () => addTodolist(),
                ),
              ],
            ),
          ),
          Divider(
            height: 50,
            color: Colors.black,
            thickness: 2,
          ),
        ],
      );
    } else {
      return SizedBox(
        height: 10,
      );
    }
  }
}
