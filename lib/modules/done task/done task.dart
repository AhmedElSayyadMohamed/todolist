import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_1/shared/component/components.dart';
import 'package:to_do_1/shared/constant/constant.dart';
import 'package:to_do_1/shared/cubit/AppState.dart';
import 'package:to_do_1/shared/cubit/cubitApp.dart';

class done_task extends StatelessWidget {
  Widget build(BuildContext context) {
    return BlocConsumer<to_do_cubit, to_do_state>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = to_do_cubit.get(context).done_tasks;
        return ListView.separated(
          itemBuilder: (context, index) => task_desine(tasks[index], context),
          separatorBuilder: (context, index) => Padding(
            padding: const EdgeInsetsDirectional.only(start: 20.0),
            child: Divider(
              thickness: 2,
            ),
          ),
          itemCount: tasks.length,
        );
      },
    );
  }
}
