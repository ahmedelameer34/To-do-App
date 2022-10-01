import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/cubit/states.dart';

import '../../modules/archived/archived.dart';
import '../../modules/done/done.dart';
import '../../modules/tasks/new_tasks.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialSatae());

  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  bool isBottomSheet = false;
  IconData fabIcon = Icons.edit ;
  List<Widget> screens = [const NewTasks(), const DoneTasks(), const Archived()];
  List<String> titles = ["New Tasks", "Done Tasks", "Archived Tasks"];
  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  void creatDatabase() {
    openDatabase('Tasks.db', version: 1, onCreate: (database, version) async {
      await database.execute(
          'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)');
    }, onOpen: (database) {
      getDataFromDatabase(database);
    }).then((value) {
      database = value;

      emit(CreateDatabase());
    });
  }

  late Database database;
  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) async {
      return await txn
          .rawInsert(
              'INSERT INTO Tasks(title, time, date, status) VALUES("$title ", "$time", "$date", "new task")')
          .then((value) {
        emit(InsertDatabase());
        getDataFromDatabase(database);
      });
    });
  }

  void getDataFromDatabase(database) {

     newTasks = [];
     doneTasks = [];
     archivedTasks = [];

    emit(LoadingState());
    database.rawQuery('SELECT * FROM Tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new task') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });

      emit(GetDatabase());
    });
    
  }

  void changeBottomSheet({required IconData icon, required bool isShow}) {
    fabIcon = icon;
    isBottomSheet = isShow;
    emit(ChangeBottomSheet());
  }

  void updateDatabase({required String status, required int id}) {
    database.rawUpdate('UPDATE Tasks SET status = ? WHERE id = ?',
        [status, id]).then((value) {
          getDataFromDatabase(database);
      emit(UpdateDatabase());
    });
  }
   void deleteDatabase({ required int id}) {
    database.rawDelete('DELETE FROM Tasks WHERE id = ?',
        [ '$id']).then((value) {
          getDataFromDatabase(database);
      emit(DeleteDatabase());
    });
  }
}
