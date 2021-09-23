import 'package:flutter/material.dart';
import 'package:to_do_1/shared/constant/constant.dart';
import 'package:to_do_1/shared/cubit/cubitApp.dart';

Widget default_TextFormField({
  required TextEditingController? controller,
  required Widget? prefixIcon,
  Widget? suffixIcon,
  double radius = 50,
  required String? labelText,
  TextInputType? keyboardType,
  bool obscureText = false,
  required ValueChanged<String>? onFieldSubmitted,
  required ValueChanged<String>? onChange,
  FormFieldValidator<String>? validator,
  GestureTapCallback? onTap,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscureText,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      fillColor: Colors.white,
      filled: true,
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: Colors.blue, width: 2)),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      labelText: labelText,
    ),
    onFieldSubmitted: onFieldSubmitted,
    onChanged: onChange,
    validator: validator,
    onTap: onTap,
  );
}
////////////////////////////////////////////////////

Widget task_desine(Map task, context) {
  return Dismissible(
    key: Key(task['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 42,
            child: Text(
              task['time'],
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['title'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  task['date'],
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 5,
          ),
          IconButton(
            onPressed: () {
              to_do_cubit.get(context).update_data(
                    status: 'done',
                    id: task["id"],
                  );
            },
            icon: Icon(Icons.cloud_done_outlined),
          ),
          IconButton(
            onPressed: () {
              to_do_cubit.get(context).update_data(
                    status: 'archive',
                    id: task["id"],
                  );
            },
            icon: Icon(Icons.archive_outlined),
          ),
        ],
      ),
    ),
    background: Container(
      color: Colors.red,
      padding: EdgeInsets.only(left: 20.0),
    ),
    onDismissed: (direction) {
      to_do_cubit.get(context).delete_data(id: task['id']);
    },
  );
}
