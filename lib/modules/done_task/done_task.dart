import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_with_block/layout/ToDoAppScreen.dart';
import 'package:todo_app_with_block/shared/component.dart';
import 'package:todo_app_with_block/shared/cubit/cubit.dart';
import 'package:todo_app_with_block/shared/cubit/states.dart';

class DoneTaskScreen extends StatelessWidget {
  const DoneTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoAppCubit, ToDoAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var list = ToDoAppCubit.get(context).doneList;
        return list.length == 0 ? center() : listviewItem(list);
      },
    );
  }
}
