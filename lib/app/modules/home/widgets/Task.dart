import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/task_model.dart';
import '../home_controller.dart';

class Task extends StatelessWidget {
  final TaskModel model;

  const Task({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(model.id.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (value) =>
          context.read<HomeController>().deleteTask(model.id),
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.grey),
          ],
          border: Border.all(
            width: 1,
            color: Colors.grey,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: IntrinsicHeight(
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: Checkbox(
              value: model.finished,
              onChanged: (value) =>
                  context.read<HomeController>().checkOrUncheckTask(model),
            ),
            title: Text(
              model.description,
              style: TextStyle(
                decoration: model.finished ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(
              DateFormat('dd/MM/y').format(model.dateTime),
              style: TextStyle(
                decoration: model.finished ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
