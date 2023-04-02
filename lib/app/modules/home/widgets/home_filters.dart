import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/ui/theme_extensions.dart';
import '../../../models/task_filter_enum.dart';
import '../../../models/total_tasks_model.dart';
import '../home_controller.dart';
import 'todo_card_filter.dart';

class HomeFilters extends StatelessWidget {
  const HomeFilters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FILTROS',
          style: context.titleStyle,
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              TodoCardFilter(
                taskFilter: TaskFilterEnum.today,
                totalTasksModel:
                    context.select<HomeController, TotalTasksModel?>(
                  (controller) => controller.todayTotalTasks,
                ),
                selected: context.select<HomeController, TaskFilterEnum>(
                        (value) => value.filterSelected) ==
                    TaskFilterEnum.today,
              ),
              TodoCardFilter(
                taskFilter: TaskFilterEnum.tomorrow,
                totalTasksModel:
                    context.select<HomeController, TotalTasksModel?>(
                  (controller) => controller.tomorrowTotalTasks,
                ),
                selected: context.select<HomeController, TaskFilterEnum>(
                        (value) => value.filterSelected) ==
                    TaskFilterEnum.tomorrow,
              ),
              TodoCardFilter(
                taskFilter: TaskFilterEnum.week,
                totalTasksModel:
                    context.select<HomeController, TotalTasksModel?>(
                  (controller) => controller.weekTotalTasks,
                ),
                selected: context.select<HomeController, TaskFilterEnum>(
                        (value) => value.filterSelected) ==
                    TaskFilterEnum.week,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
