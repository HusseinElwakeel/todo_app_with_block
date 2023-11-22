import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo_app_with_block/shared/cubit/cubit.dart';

// Widget defaultButton({
//   double width = double.infinity,
//   Color backGroundColor = Colors.blue,
//   bool isUpperCase = true,
//   double radius = 0.0,
//   required void Function() onTap,
//   required String text,
// }) => Container(
//     width: width,
//     decoration: BoxDecoration(
//         color: backGroundColor,
//         borderRadius: BorderRadius.circular(radius)),
//     child: MaterialButton(
//       onPressed: onTap,
//       child: Text(
//         isUpperCase ? text.toUpperCase() : text,
//         style: TextStyle(
//             fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
//       ),
//     ));

Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  required dynamic validator,
  Function? onSubmit,
  Function? onChanged,
  Function? onTap,
  bool isClickable = true,
  bool isPassword = false,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function()? suffixClicked,
}) =>
// when click on floating action button
    TextFormField(
      style: TextStyle(color: Color.fromRGBO(139, 69, 19, 1)),
      controller: controller,
      keyboardType: type,
      enabled: isClickable,
      validator: validator,
      onFieldSubmitted: (s) {
        onSubmit!(s);
      },
      onTap: () {
        onTap!();
      },
      obscureText: isPassword,
      onChanged: (value) {
        print(value);
      },
      decoration: InputDecoration(
          prefixIconColor: Color.fromRGBO(205, 133, 63, 1),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide:
                BorderSide(width: 3, color: Color.fromRGBO(210, 105, 30, 1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 3,
              color: Color.fromRGBO(245, 222, 179, 1),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          labelText: label,
          labelStyle: TextStyle(
            color: Color.fromRGBO(205, 133, 63, 1),
          ),
          prefixIcon: Icon(prefix),
          suffixIcon: suffix != null
              ? IconButton(
                  onPressed: () {
                    suffixClicked!();
                  },
                  icon: Icon(
                    suffix,
                  ),
                )
              : null,
          border: OutlineInputBorder()),
    );

Widget defaultTextButton(
        {required void Function() onTap, required String text}) =>
    TextButton(
      onPressed: () {
        onTap();
      },
      child: Text(text.toUpperCase()),
    );
//Dismissible to swipe right and left to delete
Widget buildTaskItem(Map model, context) => Dismissible(
      //Dismissible need key should be string and it value is string and child and   onDismissed: (direction) {),
      key: Key(model["id"].toString()),
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            CircleAvatar(
              backgroundColor: Color.fromRGBO(160, 82, 45, 1),
              radius: 30,
              child: Text(
                "${model['Time']}",
                style: TextStyle(
                  color: Color.fromRGBO(253, 245, 230, 1),
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Center(
                        child: Text(
                          "${model['title']}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            // color: Color.fromRGBO	(205,133,63,0.7),
                            color: Color.fromRGBO(160, 82, 45, 1),

                            // fontWeight:FontWeight.w100,

                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_month,
                            size: 18,
                            color: Color.fromRGBO(160, 82, 45, 1),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${model['date']}",
                            style: TextStyle(
                                color: Color.fromRGBO(205, 133, 63, 0.6),
                                fontSize: 12,
                                fontWeight: FontWeight.w100),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                ToDoAppCubit.get(context)
                    .updateData(status: 'done', id: model['id']);
              },
              icon: Icon(
                Icons.check_circle,
                color: Color.fromRGBO(160, 82, 45, 1),
              ),
            ),
            IconButton(
              onPressed: () {
                ToDoAppCubit.get(context)
                    .updateData(status: 'archive', id: model['id']);
              },
              icon: Icon(
                Icons.archive,
                color: Color.fromRGBO(160, 82, 45, 1),
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        // direction you want to delete
        DismissDirection.horizontal;
        ToDoAppCubit.get(context).deleteData(id: model["id"]);
      },
    );

Widget center() => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            size: 50,
            color: Color.fromRGBO(205, 133, 63, 0.3),
          ),
          Text(
            "No Tasks Yet ...",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromRGBO(205, 133, 63, 0.3),
              fontSize: 20,
            ),
          )
        ],
      ),
    );

Widget listviewItem(list) => ListView.separated(
      itemBuilder: (context, index) => buildTaskItem(list[index], context),
      separatorBuilder: (context, builder) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 50,
        ),
        child: Container(
          height: 1,
          width: double.infinity,
          color: Color.fromRGBO(205, 133, 63, 0.3),
        ),
      ),
      itemCount: list.length,
    );
