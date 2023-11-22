import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_with_block/modules/archeive_task/archeive_task.dart';
import 'package:todo_app_with_block/modules/done_task/done_task.dart';
import 'package:todo_app_with_block/modules/new_task/new_task.dart';
import 'package:todo_app_with_block/shared/constant.dart';
import 'package:todo_app_with_block/shared/cubit/states.dart';

late Database database;

class ToDoAppCubit extends Cubit<ToDoAppStates> {
  ToDoAppCubit() : super(ToDoAppInitialState());

  static ToDoAppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> Screens = [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen(),
  ];
  late List<Map> newList = [];
  late List<Map> doneList = [];
  late List<Map> archivedList = [];
  late List<Map> tasks = [];

  List<String> titles = [
    "New Task Screen",
    "Done Task Screen",
    "Archived Task Screen",
  ];

  void changeNavBar(int index) {
    currentIndex = index;
    emit(ToDoAppChangeState());
  }

  void createDataBase() {
    openDatabase(
      "todo.db", version: 1, // "todo.db"   الى هو اسم الداتا بيز path //
      // table بيتغير لما اغير ال  version
      onCreate: (database, version) async {
        print("Database is created ");

        await database
            .execute(
                'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, Time Text , status Text)')
            .then((value) {
          print("table is created ");
        }).catchError((error) {
          ("there are error ${error.toString()}");
        });
      }, // هناخد object من الداتا بيز
// () الحاجه هنا الى بتدهالى

      onOpen: (database) {
        print("Database is opened ");
        getDataFromDataBase(database);
        //  next to get from database
        //  هنبعتلها الداتا بيز
      },
    ).then((value) {
      database = value;
      emit(ToDoAppCreateDataBase());
    });
  }

  insertToDatabase({
    required String? title,
    required String? date,
    required String? time,
  }) async {
    await database.transaction((txn) {
      return txn
          .rawInsert(
        "INSERT INTO Tasks(title,date,Time,status) VALUES('$title','$date','$time','New Task')",
      )
          .then((value) {
        print("$value database is inserted");
        emit(ToDoAppInsertToDataBase());

        getDataFromDataBase(database);
      }).catchError((error) {
        print("there are error in insert ${error.toString()}");
      });
    });
  }

//........... To get Data from Database ...............//
// void getDataFromDatabase(databas)async{
//  List<Map> list =  await database.rawQuery("Select * FROM Tasks");
//  print(list);
// // // select *(=) all from task(table your create)
// }
//   late  List<Map>newList=[];
//   late  List<Map>doneList=[];
//   late  List<Map>archivedList=[];

  // var newTask;
  // var doneTask;
  // var archivedTask;

  void getDataFromDataBase(database) {
    database.rawQuery("Select * From Tasks").then((value) {
      // // setState(() {
      tasks = value;
      newList = [];
      doneList = [];
      archivedList = [];
      // print(list);

      tasks.forEach((element) {
        if (element["status"] == "New Task") {
          newList.add(element);
        } else if (element["status"] == "done") {
          doneList.add(element);
        } else
          archivedList.add(element);
      });

      // to print the status
      // value.forEach((element) {
      //   // if(element['status']=='new'){
      //   // }
      //   print(element["status"]);
      //
      // });
      //  getDataFromDataBase(database);
      emit(ToDoAppGetFromDataBase());

      // });
      //  to get some thing from map list[0][title]
    });
  }

  bool isBottomSheetOpened = false;
  IconData fabicon = Icons.edit;

  void changeBottomNavSheet({
    required IconData icon,
    required bool isOpen,
  }) {
    fabicon = icon;
    isBottomSheetOpened = isOpen;
    emit(ToDoAppChangeBottomSheet());
  }

  void updateData({
    required String status,
    required int id,
  }) {
// Update some record

    database.rawUpdate(
        'UPDATE Tasks SET status = ? WHERE id = ?',
// table name and what i want edit
// هعمل update  لايه ؟
// rawUpdate هنشوفها هى ايه من خلال

        ['${status}', id]).then((value) {
      getDataFromDataBase(database);
      emit(ToDoAppUpdateToDataBase());
      // print("update ${value}");
    });
  }

  void deleteData({
    // هتعمل delete ع حسب ايه ؟ هنا هعمل ع حسب ال id
    required int id,
  }) {
    // Delete a record
    //from sqflite
    // from table and where what want to  delete from ,[id] id you put to them
    database.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
      //  things u want to delete,[value]
      getDataFromDataBase(database);
      emit(ToDoAppDeleteDataFromDataBase());
    });
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:todo_app_with_block/modules/archeive_task/archeive_task.dart';
// import 'package:todo_app_with_block/modules/done_task/done_task.dart';
// import 'package:todo_app_with_block/modules/new_task/new_task.dart';
// import 'package:todo_app_with_block/shared/constant.dart';
// import 'package:todo_app_with_block/shared/cubit/states.dart';
//
//
// late Database database;
// late  List<Map>list=[];
//
// late  List<Map>newlist=[];
// late  List<Map>donelist=[];
// late  List<Map>archivelist=[];
//
// class ToDoAppCubit extends Cubit<ToDoAppStates> {
//   ToDoAppCubit() :super(ToDoAppInitialState());
//
//   static ToDoAppCubit get(context) => BlocProvider.of(context);
//
//
//   int currentIndex = 0;
//   List<Widget> Screens = [
//     NewTaskScreen(),
//     DoneTaskScreen(),
//     ArchivedTaskScreen(),
//   ];
//
//   List<String> titles = [
//     "New Task Screen",
//     "Done Task Screen",
//     "Archived Task Screen",
//   ];
//
//   void changeNavBar(int index) {
//     currentIndex = index;
//     emit(ToDoAppChangeState());
//   }
//
//   void createDataBase()  {
//     openDatabase(
//       "todo.db", version: 1, // "todo.db"   الى هو اسم الداتا بيز path //
//       // table بيتغير لما اغير ال  version
//       onCreate: (database, version) async {
//         print("Database is created ");
//
//         await database
//             .execute(
//             'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, Time Text , status Text)')
//             .then((value) {
//           print("table is created ");
//         }).catchError((error) {
//           ("there are error ${error.toString()}");
//         });
//       }, // هناخد object من الداتا بيز
// // () الحاجه هنا الى بتدهالى
//
//       onOpen: (database) {
//         print("Database is opened ");
//         getDataFromDataBase(database);
//         //  next to get from database
//         //  هنبعتلها الداتا بيز
//       },
//     ).then((value)
//     {
//       database=value;
//       emit(ToDoAppCreateDataBase());
//     }
//     );
//   }
//
//
//   insertToDatabase({
//     required String ?title,
//     required String ?date,
//     required String ?time,
//
//   }) async {
//     await database.transaction((txn) {
//       return txn.rawInsert(
//         "INSERT INTO Tasks(title,date,Time,status) VALUES('$title','$date','$time','New Task')",
//       ).then((value) {
//         print("$value database is inserted");
//         emit(ToDoAppInsertToDataBase());
//         getDataFromDataBase(database);
//       }).catchError(
//               (error) {
//             print("there are error in insert ${error.toString()}");
//           });
//     });
//   }
// //........... To get Data from Database ...............//
// // void getDataFromDatabase(databas)async{
// //  List<Map> list =  await database.rawQuery("Select * FROM Tasks");
// //  print(list);
// // // // select *(=) all from task(table your create)
// // }
//   void  getDataFromDataBase(database)  {
//
//     newlist=[];
//     donelist=[];
//     archivelist=[];
//
//      database.rawQuery("Select * From Tasks").then((value) {
//        // setState(() {
//        list=value;
//        print(list);
//
//
//
//        // print(value);
// // value.forEach((element)
// // {
// //   if(element["status"]=="new"){
// //     newlist.add(element);
// //     print(element);
// //   }
// //
// //   else if(element["status"]=="done"){
// //     donelist.add(element);
// //   }
// //   else archivelist.add(element);
// // });
// emit(ToDoAppGetFromDataBase());
// });
//        // });
//      }
//
//   bool isBottomSheetOpened = false;
//   IconData fabicon = Icons.edit;
//
//
//   void changeBottomNavSheet(
//       {
//         required IconData icon,
//         required bool isOpen,
//       }
//       ){
//
//     fabicon=icon;
//     isBottomSheetOpened=isOpen;
//     emit(ToDoAppChangeBottomSheet());
//
//
//   }
//
//
//   void UpdateData(
//   {
//     required String status,
//     required int id,
// }
//     ){
//
//   // Update some record
//   database.rawUpdate(
//           'UPDATE Tasks SET status = ? WHERE id = ?',
//       ['${status}', id]).then((value) {
//
//         getDataFromDataBase(database);
//  emit(ToDoAppUpdateToDataBase());
//
//
//   });
//
//
//
// }
// }
//
//
