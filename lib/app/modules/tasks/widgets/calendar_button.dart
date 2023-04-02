import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/ui/theme_extensions.dart';
import '../task_create_controller.dart';

class CalendarButton extends StatelessWidget {
  final TaskCreateController controller;
  final dateFormat = DateFormat('dd/MM/yyyy');

  CalendarButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var lastDate = DateTime.now();
        lastDate = lastDate.add(const Duration(days: 10 * 365));

        final DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: lastDate,
        );

        controller.selectedDate = selectedDate;
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.today, color: Colors.grey),
            const SizedBox(width: 10),
            Selector<TaskCreateController, DateTime?>(
                selector: (context, controller) => controller.selectedDate,
                builder: (_, selectedDate, __) {
                  return Text(
                    selectedDate != null
                        ? dateFormat.format(selectedDate)
                        : 'Selecione uma data'.toUpperCase(),
                    style: context.titleStyle,
                  );
                }),
          ],
        ),
      ),
    );
  }
}
