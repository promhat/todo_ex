import 'package:flutter/material.dart';
import 'package:khi_todo/todolist.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        primaryColor: Colors.white,
      ),
      home: myTodolist(),
      debugShowCheckedModeBanner: false,
    );
  }
}
