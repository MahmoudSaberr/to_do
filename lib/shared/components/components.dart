import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';

import '../cubit/cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3.0,
  @required Function function,
  @required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );

Widget defaultFormField({
  @required TextEditingController controller,
  @required TextInputType type,
  Function onSubmit,
  Function onChange,
  Function onTap,
  bool isPassword = false,
  @required Function validate,
  @required String label,
  @required IconData prefix,
  IconData suffix,
  Function suffixPressed,
  bool isClickable = true,
  bool readOnly = false,
}) =>
    TextFormField(
      readOnly: readOnly,
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
          onPressed: suffixPressed,
          icon: Icon(
            suffix,
          ),
        )
            : null,
        border: OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model, context1) => Dismissible(
  key: Key(model['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text(
                '${model['time']}',
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            IconButton(
              onPressed: ()
              {
                AppCubit.get(context1).updateData(
                  status: 'done',
                  id: model['id'],
                );
              },
              icon: Icon(
                Icons.check_box,
                color: Colors.blue,
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context1).updateData(
                  status: 'archive',
                  id: model['id'],
                );
              },
              icon: Icon(
                Icons.archive,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: Colors.white,
          gradient: new LinearGradient(
              stops: [0.02, 0.02],
              colors: [Colors.blue, Colors.white]
          ),
        ),
        padding: EdgeInsetsDirectional.only(
          start: 20.0,
          end: 10.0,
          top: 5.0,
          bottom: 5.0,
        ),
      ),
    ),
  confirmDismiss: (DismissDirection direction) async {
    return await showDialog(
      context: context1,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text("Delete Confirmation"),
            content: const Text("Are you sure you want to delete this item?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: ()
                  {
                    Navigator.of(context).pop(true);
                    AppCubit.get(context1).deleteData(id: model['id'],);
                  },
                  child: const Text("Delete")
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
            ],
          );
        },
    );
    },
  background: Container(
    color: Colors.red,
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Icon(
            Icons.delete_forever,
            color: Colors.white,
            size: 25.0,
          ),
          SizedBox(
            width: 20.0,
          ),
          Text(
              'Delete Item',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
              ),
          ),
        ],
      ),
    ),
  ),
);

Widget tasksBuilder({
  @required List<Map> tasks,
}) => ConditionalBuilder(
  condition: tasks.length > 0,
  builder: (context) => ListView.separated(
    itemBuilder: (context, index)
    {
      return buildTaskItem(tasks[index], context);
    },
    separatorBuilder: (context, index) => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20.0,
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    ),
    itemCount: tasks.length,
  ),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100.0,
          color: Colors.grey,
        ),
        Text(
          'No Tasks Yet, Please Add Some Tasks',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  ),
);