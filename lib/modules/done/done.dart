import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class DoneTasks extends StatelessWidget {
  const DoneTasks({super.key});

  
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>(
    listener:((context, state) {} ),
    builder:(context, state) {
      var tasks =AppCubit.get(context).doneTasks;
      return
       screensBuilder(tasks: tasks,statusOfTaskScreen:'No done tasks yet' );
       }
     
   );
  }
}