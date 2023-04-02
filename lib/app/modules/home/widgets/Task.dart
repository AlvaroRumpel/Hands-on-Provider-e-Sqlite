import 'package:flutter/material.dart';

class Task extends StatelessWidget {
  const Task({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            value: true,
            onChanged: (value) {},
          ),
          title: Text(
            'Descrição da task',
            style: TextStyle(
              decoration: false ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            '20/03/23',
            style: TextStyle(
              decoration: false ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ),
    );
  }
}
