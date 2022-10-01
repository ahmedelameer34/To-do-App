import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import '../shared/components/components.dart';

import '../shared/cubit/states.dart';
import '../shared/styles/colors.dart';

class HomeLayout extends StatelessWidget {
  late Database database;
  var scffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..creatDatabase(),
      child: BlocConsumer<AppCubit, AppState>(
        builder: (BuildContext context, AppState state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            backgroundColor: bodyColor,
            key: scffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
                style: const TextStyle(color: Colors.grey, fontSize: 24),
              ),
              backgroundColor: mainColor,
            ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: mainColor,
                onPressed: () {
                  if (cubit.isBottomSheet) {
                    if (formKey.currentState!.validate()) {
                      cubit.insertToDatabase(
                          date: dateController.text,
                          time: timeController.text,
                          title: titleController.text);
                    }
                  } else {
                    scffoldKey.currentState!
                        .showBottomSheet((context) => SingleChildScrollView(
                              child: Container(
                                height: 350,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: bodyColor,
                                ),
                                padding: const EdgeInsets.all(20),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      defTextFormField(
                                        onChange: () {},
                                        onTap: () {},
                                        onSubmit: () {},
                                        controller: titleController,
                                        textType: TextInputType.text,
                                        label: 'Task title:',
                                        prefix: Icons.title,
                                        validate: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'title must be not empty';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      defTextFormField(
                                        onSubmit: () => null,
                                        onChange: () => null,
                                        onTap: () {
                                          showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now())
                                              .then((value) {
                                            timeController.text = value!
                                                .format(context)
                                                .toString();
                                          });
                                        },
                                        controller: timeController,
                                        textType: TextInputType.none,
                                        label: 'Task time:',
                                        prefix: Icons.watch_later_outlined,
                                        validate: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'time must be not empty';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      defTextFormField(
                                        onSubmit: () => null,
                                        onChange: () => null,
                                        onTap: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime(2025))
                                              .then((value) {
                                            dateController.text =
                                                DateFormat.yMMMd()
                                                    .format(value!);
                                          });
                                        },
                                        controller: dateController,
                                        textType: TextInputType.none,
                                        label: 'Task date:',
                                        prefix: Icons.calendar_today,
                                        validate: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'date must be not empty';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ))
                        .closed
                        .then((value) {
                      cubit.changeBottomSheet(icon: Icons.edit, isShow: false);
                    });
                    cubit.changeBottomSheet(icon: Icons.add, isShow: true);
                    // });
                  }
                },
                child: Icon(
                  cubit.fabIcon,
                  color: Colors.grey,
                )),
            bottomNavigationBar: CurvedNavigationBar(
              color: mainColor,
              animationDuration: const Duration(milliseconds: 700),
              buttonBackgroundColor: bodyColor,
              backgroundColor: Colors.white,
              animationCurve: Curves.easeInOutBack,
              items: const [
                Icon(
                  Icons.menu,
                  color: Colors.grey,
                  size: 32,
                ),
                Icon(Icons.check_circle_rounded,
                    color: Color.fromARGB(255, 23, 168, 4), size: 32),
                Icon(Icons.archive_rounded,
                    color: Color.fromARGB(255, 123, 126, 123), size: 32)
              ],
              onTap: (index) => cubit.changeIndex(index),
            ),

            //other params

            body: ConditionalBuilder(
              condition: state is! LoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
          );
        },
        listener: (BuildContext context, AppState state) {
          if (state is InsertDatabase) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
