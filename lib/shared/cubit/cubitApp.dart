import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_1/modules/archive/archive.dart';
import 'package:to_do_1/modules/done%20task/done%20task.dart';
import 'package:to_do_1/modules/new%20task/new%20task.dart';
import 'package:to_do_1/shared/constant/constant.dart';
import 'package:to_do_1/shared/cubit/AppState.dart';

class to_do_cubit extends Cubit<to_do_state> {
  bool isBottomSheetShow = false;
  int bottomNaviBar_index = 0;
  Database? database;
  Widget fabIcon = Icon(Icons.edit);
  List<Map> new_tasks = [];
  List<Map> done_tasks = [];
  List<Map> archive_tasks = [];
  ////////////////////////////////////

  to_do_cubit() : super(initialState());

  static to_do_cubit get(context) => BlocProvider.of(context);

  List<String> title = [
    'New Task',
    'Done Task',
    'Archive Screen',
  ];

  List<Widget> screen = [
    new_task(),
    done_task(),
    archive_screen(),
  ];

  void changeIndex(index) {
    bottomNaviBar_index = index;
    emit(change_navigation_bar_icon());
  }

  void change_fabIcon({
    required Icon icon,
    required bool isBotomSheetShow,
  }) {
    isBottomSheetShow = isBotomSheetShow;
    fabIcon = icon;
    emit(fab_editIcon());
  }
///////////database //////////////////

  void create_database() {
    openDatabase(
      'To Do.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');

        database
            .execute(
                'CREATE TABLE Tasks(id Integer primary key , title Text,time Text,date Text,status Text)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('error when table created${error.toString()}');
        });
      },
      onOpen: (database) {
        getdata_from_database(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(create_data_base());
    });
  }

  insert_data_to_database({
    required title,
    required time,
    required date,
  }) {
    database?.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO Tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value : record inserted successful');
        emit(insert_data_base());
        getdata_from_database(database);
      }).catchError((error) {
        print('error when insert record ${error.toString()}');
      });
    });
  }

  void getdata_from_database(database) {
    new_tasks = [];
    done_tasks = [];
    archive_tasks = [];

    database?.rawQuery('SELECT *FROM Tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          new_tasks.add(element);
        } else if (element['status'] == 'done') {
          done_tasks.add(element);
        } else {
          archive_tasks.add(element);
        }
      });
      emit(get_data_base());
    });
    ;
  }

  void update_data({
    required String status,
    required int id,
  }) {
    database?.rawUpdate('UPDATE Tasks set status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getdata_from_database(database);
      emit(update_database());
    });
  }

  void delete_data({
    required int id,
  }) {
    database?.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
      getdata_from_database(database);
      emit(delete_database());
    });
  }
}
