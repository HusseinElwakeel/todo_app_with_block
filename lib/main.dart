import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_with_block/layout/ToDoAppScreen.dart';
import 'package:todo_app_with_block/modules/constant/observe.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}
