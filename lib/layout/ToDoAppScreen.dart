import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_with_block/modules/archeive_task/archeive_task.dart';
import 'package:todo_app_with_block/modules/done_task/done_task.dart';
import 'package:todo_app_with_block/modules/new_task/new_task.dart';
import 'package:todo_app_with_block/shared/component.dart';
import 'package:todo_app_with_block/shared/constant.dart';
import 'package:todo_app_with_block/shared/cubit/cubit.dart';
import 'package:todo_app_with_block/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  var name;
  var titleController = TextEditingController();
  var timecontroller = TextEditingController();

  var formkey = GlobalKey<FormState>();
  late String? value;
  var dateControoler = TextEditingController();

  // ToDoAppCubit c = ToDoAppCubit.get(context);

  var scaffoldkey = GlobalKey<ScaffoldState>();

// void initState() {
//   super.initState();
//   createDataBase();
// }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ToDoAppCubit()..createDataBase(),
      child: BlocConsumer<ToDoAppCubit, ToDoAppStates>(
        listener: (BuildContext context, state) {
          if (state is ToDoAppInsertToDataBase) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, state) {
          var list = ToDoAppCubit.get(context).tasks;

          // late List<Map>list;

          return Scaffold(
            backgroundColor: Color.fromRGBO(253, 245, 230, 1),
            key: scaffoldkey,
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(160, 82, 45, 1),
              title: Text(ToDoAppCubit.get(context)
                  .titles[ToDoAppCubit.get(context).currentIndex]),
            ),
            body: list.length == 0
                ? Center(child: CircularProgressIndicator())
                : ToDoAppCubit.get(context)
                    .Screens[ToDoAppCubit.get(context).currentIndex],
            floatingActionButton: FloatingActionButton(
              backgroundColor: Color.fromRGBO(160, 82, 45, 1),
              onPressed: () async {
                if (ToDoAppCubit.get(context).isBottomSheetOpened) {
                  if (formkey.currentState!.validate()) {
                    ToDoAppCubit.get(context).insertToDatabase(
                        title: titleController.text,
                        date: dateControoler.text,
                        time: timecontroller.text);
                  }
                } else {
                  scaffoldkey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          color: Color.fromRGBO(250, 240, 230, 1),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formkey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultTextFormField(
                                    controller: titleController,
                                    type: TextInputType.text,
                                    onTap: () {
                                      print(
                                          "text tapped.........................................");
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        // print("value must not be empty") ;
                                        return "Text must not be empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                    label: "Text",
                                    prefix: Icons.title_sharp,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  defaultTextFormField(
                                    controller: timecontroller,
                                    type: TextInputType.datetime,
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                        builder: (context, child) {
                                          return Theme(
                                            data: ThemeData.light().copyWith(
                                              colorScheme: ColorScheme.light(
                                                // change the border color
                                                primary: Color.fromRGBO(
                                                    205, 133, 63, 1),
                                                // change the text color
                                                onSurface: Color.fromRGBO(
                                                    160, 82, 45, 1),
                                                //background for clock
                                                onBackground: Color.fromRGBO(
                                                    210, 105, 30, 1),
                                                // to change selected time
                                                // onPrimary: Color.fromRGBO(0,0,0, 1),
                                                // onPrimary: Colors.pink,
                                                // onSecondary: Colors.pink,
                                                //to change background color of clock
                                                surface: Color.fromRGBO(
                                                    253, 245, 230, 1),
                                              ),
                                              timePickerTheme:
                                                  TimePickerThemeData(
                                                // dialTextColor: Colors.cyan,

                                                // to change select time color
                                                helpTextStyle: TextStyle(
                                                  fontSize: 12,
                                                  color: Color.fromRGBO(
                                                      205, 133, 63, 1),
                                                  // backgroundColor: Colors.cyan,
                                                ),
                                              ),

                                              // button colors
                                              // buttonTheme: ButtonThemeData(
                                              //   colorScheme: ColorScheme.light(
                                              //     primary: Colors.green,
                                              //
                                              //   ),
                                              // ),
                                            ),
                                            child: child!,
                                          );
//                                          child: const Text('Click me');
                                        },
                                      ).then((value) {
                                        timecontroller.text =
                                            value!.format(context);
                                        print(value!.format(context));
                                      });
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "time must not be emppty";
                                      }
                                      return null;
                                    },
                                    label: "Time:",
                                    prefix: Icons.access_time_filled,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  defaultTextFormField(
                                      controller: dateControoler,
                                      type: TextInputType.datetime,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Date must not be empty";
                                        } else {
                                          return null;
                                        }
                                      },
                                      label: "Date:",
                                      prefix: Icons.date_range_outlined,
                                      onTap: () {
                                        showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate:
                                                DateTime.parse("1950-04-20"),
                                            lastDate:
                                                DateTime.parse("2100-05-03"),
                                            // we pass to them the child to return in child the child
                                            // TO CHANGE THE COLOR OF DATE PICKER
                                            builder: (context, child) {
                                              return Theme(
                                                data:
                                                    Theme.of(context).copyWith(
                                                  //should br dark
                                                  colorScheme: ColorScheme.dark(
                                                    // selected color
                                                    primary: Color.fromRGBO(
                                                        255, 235, 205, 1),
                                                    //color number in selected
                                                    onPrimary: Color.fromRGBO(
                                                        160, 82, 45, 1),
                                                    // bckground of color of up part
                                                    surface: Color.fromRGBO(
                                                        255, 235, 205, 1),
                                                    //background of text in up and numbers
                                                    onSurface: Color.fromRGBO(
                                                        205, 133, 63, 1),
                                                  ),
                                                  // to change background
                                                  dialogBackgroundColor:
                                                      Color.fromRGBO(
                                                          255, 250, 230, 1),

                                                  //cancel and ok color
                                                  textButtonTheme:
                                                      TextButtonThemeData(
                                                    style: TextButton.styleFrom(
                                                      primary: Color.fromRGBO(
                                                          205, 133, 63, 1),
                                                      // button text color
                                                    ),
                                                  ),
                                                ),
                                                child: child!,
                                              );
                                            }).then((value) {
                                          print(DateFormat.yMMMd()
                                              .format(value!));
                                          dateControoler.text =
                                              DateFormat.yMMMd().format(value!);
                                        });
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ),

                        //  ده عشان لو قفلتها بإيدى هتحصل مشكله فده بيحل المشكله
                      )
                      .closed
                      .then((value) {
                    // Navigator.pop(context);   انا الى بنزله بإيدى
                    ToDoAppCubit.get(context)
                        .changeBottomNavSheet(icon: Icons.edit, isOpen: false);
                    // setState(() {
                    //   fabicon = Icons.add;
                    //
                    // });
                  });
                  ToDoAppCubit.get(context)
                      .changeBottomNavSheet(icon: Icons.add, isOpen: true);
                  // isBottomSheetOpened = true;
                  // setState(() {
                  //   fabicon= Icons.add;
                  // });
                }
                // فى حاله then مش هعمل async or  await
                // try{
                //   name = await getName();
                //   print(name);
                /////   throw("There are Error !!!!");   // عشان نعمل error
                // }
                // catch(error){
                //   print("error is : ${error.toString()}");
                // }
// try {
//   var h = await getN();
//   print(h);
// }
// catch(error){
//   print(error);
//           }
//           getN().then((value) {
//             print(value);
//             print("osama");
//             throw("انا عملت ايرور ");
// }).catchError((error)
//           {
//             print("error is${error.toString()}");
//           }
//           );

                // getName().then((value) {
                //   print(value);
                //   print("hussein");
                //   // throw ("there are  errors ");  // عشان اعمل error
                // }).catchError((error) {
                //   print("errors is : ${error.toString()}");
                // });
                // insertToDatabase();
              },
              child: Icon(ToDoAppCubit.get(context).fabicon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Color.fromRGBO(139, 69, 19, 1),
              // fixedColor: Colors.cyan,
              selectedFontSize: 15,
              // selectedIconTheme: IconThemeData(fill: double.maxFinite),
              unselectedItemColor: Color.fromRGBO(205, 133, 63, 0.7),
              backgroundColor: Color.fromRGBO(255, 250, 250, 1),
              // backgroundColor: Colors.blue,
              elevation: 90,
              showSelectedLabels: true,
// بتظهر الى مختاره

              type: BottomNavigationBarType.fixed,
              currentIndex: ToDoAppCubit.get(context).currentIndex,
              onTap: (index) {
                // // setState(() {
                //   ToDoAppCubit.get(context).currentIndex = index;
                ToDoAppCubit.get(context).changeNavBar(index);
                // });
              },

              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.table_rows_sharp,
                      // color: Color.fromRGBO(210,180,140,1)
                    ),
                    label: "New Tasks",
                    backgroundColor: Color.fromRGBO(210, 180, 140, 1)),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.done_all,
                      // color:Color.fromRGBO(210,180,140,1)
                    ),
                    label: "Done",
                    backgroundColor: Color.fromRGBO(210, 180, 140, 1)),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                    // color:Color.fromRGBO(210,180,140,1)),
                  ),
                  label: "Archived",
                ),
              ],
            ),
          );
        },
      ),
    );
  }

// version for sqflite is: sqflite: ^1.3.0 in pubspec.yaml
//وبتظهر فى pubspec.lock انى عملتلها generate

//عشان يكون عندى database لازم اعمل شويه حاجات

//1.create database
//2.create tables
//3.open database to get from it an object to able to :
//4.insert to database
//5.get from database
//6.update in database
//7.delete from database

//اى حاجه هعملها فىmethod

  Future<String> getName() async {
    return "Hussein Elwakeel";
  }
}
