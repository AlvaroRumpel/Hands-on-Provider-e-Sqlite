import 'package:provider/provider.dart';

import '../../core/database/sqlite_connection_factory.dart';
import '../../core/modules/todo_list_module.dart';
import '../../repositories/tasks/tasks_repository.dart';
import '../../repositories/tasks/tasks_repository_impl.dart';
import '../../services/tasks/tasks_service.dart';
import '../../services/tasks/tasks_service_impl.dart';
import 'task_create_controller.dart';
import 'task_create_page.dart';

class TasksModule extends TodoListModule {
  TasksModule()
      : super(
          bindings: [
            Provider<TasksRepository>(
              create: (context) => TasksRepositoryImpl(
                sqliteConnectionFactory:
                    context.read<SqliteConnectionFactory>(),
              ),
            ),
            Provider<TasksService>(
              create: (context) => TasksServiceImpl(
                taskRepository: context.read<TasksRepository>(),
              ),
            ),
            ChangeNotifierProvider(
              create: (context) => TaskCreateController(
                tasksService: context.read<TasksService>(),
              ),
            ),
          ],
          routers: {
            '/task/create': (context) => TaskCreatePage(
                  controller: context.read<TaskCreateController>(),
                ),
          },
        );
}
