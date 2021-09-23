import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_1/modules/archive/archive.dart';
import 'package:to_do_1/modules/done%20task/done%20task.dart';
import 'package:to_do_1/modules/new%20task/new%20task.dart';
import 'package:to_do_1/shared/component/components.dart';
import 'package:to_do_1/shared/constant/constant.dart';
import 'package:to_do_1/shared/cubit/AppState.dart';
import 'package:to_do_1/shared/cubit/cubitApp.dart';

class layout_screen extends StatelessWidget {
  var scaffold_key = GlobalKey<ScaffoldState>();
  var form_key = GlobalKey<FormState>();
  var titlecontroller = TextEditingController();
  var timecontroller = TextEditingController();
  var datecontroller = TextEditingController();

///////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => to_do_cubit()..create_database(),
      child: BlocConsumer<to_do_cubit, to_do_state>(
        listener: (context, state) {
          if (state is insert_data_base) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          to_do_cubit cubit = to_do_cubit.get(context);
          return Scaffold(
            key: scaffold_key,
            appBar: AppBar(
              title: Text(cubit.title[cubit.bottomNaviBar_index]),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShow) {
                  if (form_key.currentState!.validate()) {
                    cubit
                        .insert_data_to_database(
                      title: titlecontroller.text,
                      time: timecontroller.text,
                      date: datecontroller.text,
                    )
                        .then((value) {
                      cubit.change_fabIcon(
                        icon: Icon(Icons.edit),
                        isBotomSheetShow: false,
                      );
                    });
                  }
                } else {
                  scaffold_key.currentState
                      ?.showBottomSheet(
                        (context) => Container(
                          color: Colors.grey[100],
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SingleChildScrollView(
                              child: Form(
                                key: form_key,
                                child: Column(
                                  children: [
                                    default_TextFormField(
                                        controller: titlecontroller,
                                        radius: 10,
                                        prefixIcon: Icon(Icons.title),
                                        labelText: 'Task Title',
                                        onFieldSubmitted: (value) {},
                                        onChange: (value) {},
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Task title must not be empty';
                                          }
                                        }),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    default_TextFormField(
                                        controller: timecontroller,
                                        radius: 10,
                                        prefixIcon:
                                            Icon(Icons.watch_later_outlined),
                                        labelText: 'Task Time',
                                        onTap: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ).then((value) {
                                            timecontroller.text = value!
                                                .format(context)
                                                .toString();
                                          }).catchError((error) {});
                                        },
                                        onFieldSubmitted: (value) {},
                                        onChange: (value) {},
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Task time must not be empty';
                                          }
                                        }),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    default_TextFormField(
                                        controller: datecontroller,
                                        radius: 10,
                                        prefixIcon:
                                            Icon(Icons.calendar_today_sharp),
                                        labelText: 'Task date',
                                        onFieldSubmitted: (value) {},
                                        onChange: (value) {},
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2021-09-20'),
                                          ).then((value) {
                                            datecontroller.text =
                                                DateFormat.yMMMd()
                                                    .format(value!);
                                          }).catchError(() {});
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Task date must not be empty';
                                          }
                                        })
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        elevation: 20,
                      )
                      .closed
                      .then((value) {
                    cubit.change_fabIcon(
                      icon: Icon(Icons.edit),
                      isBotomSheetShow: false,
                    );
                  });
                  cubit.change_fabIcon(
                    icon: Icon(Icons.add),
                    isBotomSheetShow: true,
                  );
                }
              },
              child: cubit.fabIcon,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.bottomNaviBar_index,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.cloud_done_outlined),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archives',
                ),
              ],
            ),
            body: cubit.screen[cubit.bottomNaviBar_index],
          );
        },
      ),
    );
  }
}
