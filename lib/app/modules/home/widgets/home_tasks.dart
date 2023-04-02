import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/ui/theme_extensions.dart';
import '../../../models/task_model.dart';
import '../home_controller.dart';
import 'task.dart';

class HomeTasks extends StatelessWidget {
  const HomeTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Selector<HomeController, String>(
              selector: (context, controller) =>
                  controller.filterSelected.label,
              builder: (context, value, child) {
                return Text(
                  'TASK\' DE $value',
                  style: context.titleStyle,
                );
              }),
          Column(
            children: context
                .select<HomeController, List<TaskModel>>(
                    (controller) => controller.filteredTasks)
                .map(
                  (e) => Task(model: e),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
