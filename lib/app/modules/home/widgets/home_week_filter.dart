import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/ui/theme_extensions.dart';
import '../../../models/task_filter_enum.dart';
import '../home_controller.dart';

class HomeWeekFilter extends StatelessWidget {
  const HomeWeekFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: context.select<HomeController, TaskFilterEnum>(
              (controller) => controller.filterSelected) ==
          TaskFilterEnum.week,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Dia da semana'.toUpperCase(),
            style: context.titleStyle,
          ),
          const SizedBox(height: 10),
          Container(
            height: 95,
            child: Selector<HomeController, DateTime>(
              selector: (context, controller) =>
                  controller.initialDateWeek ?? DateTime.now(),
              builder: (context, value, child) {
                return DatePicker(
                  value,
                  locale: 'pt_BR',
                  initialSelectedDate: value,
                  selectionColor: context.primaryColor,
                  selectedTextColor: Colors.white,
                  daysCount: 7,
                  monthTextStyle: const TextStyle(fontSize: 8),
                  dayTextStyle: const TextStyle(fontSize: 12),
                  dateTextStyle: const TextStyle(fontSize: 12),
                  onDateChange: (date) =>
                      context.read<HomeController>().filterByDay(date),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
