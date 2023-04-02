import 'package:provider/provider.dart';

import '../../core/database/sqlite_connection_factory.dart';
import '../../core/modules/todo_list_module.dart';
import '../../repositories/tasks/tasks_repository.dart';
import '../../repositories/tasks/tasks_repository_impl.dart';
import '../../services/tasks/tasks_service.dart';
import '../../services/tasks/tasks_service_impl.dart';
import 'home_controller.dart';
import 'home_page.dart';

class HomeModule extends TodoListModule {
  HomeModule()
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
              create: (context) => HomeController(
                tasksService: context.read<TasksService>(),
              ),
            ),
          ],
          routers: {
            '/home': (context) => HomePage(
                  homeController: context.read<HomeController>(),
                ),
          },
        );
}
