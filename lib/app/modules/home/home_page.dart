import 'package:flutter/material.dart';

import '../../core/notifier/default_listener_notifier.dart';
import '../../core/ui/theme_extensions.dart';
import '../../core/ui/todo_list_icons.dart';
import '../../models/task_filter_enum.dart';
import '../tasks/tasks_module.dart';
import 'home_controller.dart';
import 'widgets/home_drawer.dart';
import 'widgets/home_filters.dart';
import 'widgets/home_header.dart';
import 'widgets/home_tasks.dart';
import 'widgets/home_week_filter.dart';

class HomePage extends StatefulWidget {
  final HomeController _homeController;

  const HomePage({
    Key? key,
    required HomeController homeController,
  })  : _homeController = homeController,
        super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    DefaultListenerNotifier(changeNotifier: widget._homeController).listener(
      context: context,
      successCallback: (notifier, listenerInstance) {},
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget._homeController.loadTotalTasks();
      widget._homeController.findTasks(filter: TaskFilterEnum.today);
    });
  }

  Future<void> _goToCreateTask(BuildContext context) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation = CurvedAnimation(
            parent: animation,
            curve: Curves.linearToEaseOut,
          );
          return ScaleTransition(
            scale: animation,
            alignment: Alignment.bottomRight,
            child: child,
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          return TasksModule().getPage('/task/create', context);
        },
      ),
    );

    await widget._homeController.refreshPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.primaryColor),
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFFFAFBFE),
        elevation: 0,
        actions: [
          PopupMenuButton(
            icon: const Icon(TodoListIcons.filter),
            onSelected: (value) =>
                widget._homeController.showOrHideFinishedTasks(),
            itemBuilder: (_) => [
              PopupMenuItem<bool>(
                value: true,
                child: Text(
                    '${widget._homeController.showFinishedTask ? 'Esconder' : 'Mostrar'} tarefas concluidas'),
              )
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.primaryColor,
        onPressed: () => _goToCreateTask(context),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFFFAFBFE),
      drawer: HomeDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      HomeHeader(),
                      HomeFilters(),
                      HomeWeekFilter(),
                      HomeTasks(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
