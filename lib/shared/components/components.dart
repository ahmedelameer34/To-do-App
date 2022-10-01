import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

import '../styles/colors.dart';

Widget defTextFormField({
  required TextEditingController controller,
  required TextInputType textType,
  Function()? onSubmit,
  Function()? onChange,
  required Function validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function? onTap,
  bool isClickable = true,
}) =>
    TextFormField(
        controller: controller,
        keyboardType: textType,
        onTap: () {
          onTap!();
        },
        onChanged: (s) {
          onChange!();
        },
        onFieldSubmitted: (s) {
          onSubmit!();
        },
        validator: (s) => validate(s),
        enabled: isClickable,
        decoration: InputDecoration(
            prefixIcon: Icon(
              prefix,
              size: 30,
            ),
            labelText: label,
            labelStyle: const TextStyle(fontSize: 24)));
Widget taskBuilder(Map model, context) {
  return Dismissible(
    key: Key(model['id'].toString()),
    onDismissed: (direction) {
      AppCubit.get(context).deleteDatabase(id: model['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 40,
            child: Text(
              '${model['time']}',
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
            ),
          ),
          const SizedBox(
            width: 40,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model['title']}',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text('${model['date']}',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 59, 59, 59), fontSize: 16))
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDatabase(status: 'done', id: model['id']);
              },
              icon: const Icon(
                Icons.check_circle_rounded,
                color: Color.fromARGB(255, 23, 168, 4), size: 32,
              )),
          IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDatabase(status: 'archived', id: model['id']);
              },
              icon: const Icon(
                Icons.archive,
                color: Colors.grey,size: 32
              ))
        ],
      ),
    ),
  );
}

Widget screensBuilder(
        {required List<Map> tasks, required String statusOfTaskScreen}) =>
    ConditionalBuilder(
        condition: tasks.isNotEmpty,
        builder: (context) => ListView.separated(
              itemBuilder: (context, index) =>
                  taskBuilder(tasks[index], context),
              separatorBuilder: (context, index) => Container(
                width: double.infinity,
                height: 2,
                color: const Color.fromARGB(255, 197, 166, 166),
              ),
              itemCount: tasks.length,
            ),
        fallback: (context) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(
                    Icons.menu,color: textColor,
                    size: 34,
                  ),
                  Text(
                    statusOfTaskScreen,
                    style:  TextStyle(fontSize: 20,color:textColor ),
                  )
                ],
              ),
            ));
