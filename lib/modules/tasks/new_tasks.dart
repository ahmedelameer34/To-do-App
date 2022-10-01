import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';

import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class NewTasks extends StatelessWidget {
  const NewTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
        listener: ((context, state) {}),
        builder: (context, state) {
          var tasks = AppCubit.get(context).newTasks;
          return screensBuilder(
              tasks: tasks,
              statusOfTaskScreen: 'No new tasks yet , add some tasks');
        });
  }
}
