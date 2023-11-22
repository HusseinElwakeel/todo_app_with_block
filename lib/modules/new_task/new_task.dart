import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_with_block/layout/ToDoAppScreen.dart';
import 'package:todo_app_with_block/shared/component.dart';
import 'package:todo_app_with_block/shared/constant.dart';
import 'package:todo_app_with_block/shared/cubit/cubit.dart';
import 'package:todo_app_with_block/shared/cubit/states.dart';

class NewTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // لازم ال
    return BlocConsumer<ToDoAppCubit, ToDoAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var list = ToDoAppCubit.get(context).newList;
        return list.length == 0 ? center() : listviewItem(list);
      },
    );
  }
}
