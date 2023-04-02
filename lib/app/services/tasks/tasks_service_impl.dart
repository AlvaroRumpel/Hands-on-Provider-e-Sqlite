import '../../models/task_model.dart';
import '../../models/week_task_model.dart';
import '../../repositories/tasks/tasks_repository.dart';
import 'tasks_service.dart';

class TasksServiceImpl implements TasksService {
  final TasksRepository _tasksRepository;

  TasksServiceImpl({required TasksRepository taskRepository})
      : _tasksRepository = taskRepository;

  @override
  Future<void> save(DateTime date, String description) =>
      _tasksRepository.save(date, description);

  @override
  Future<List<TaskModel>> getToday() =>
      _tasksRepository.findByPeriod(DateTime.now(), DateTime.now());

  @override
  Future<List<TaskModel>> getTomorrow() {
    var tomorrow = DateTime.now().add(const Duration(days: 1));
    return _tasksRepository.findByPeriod(tomorrow, tomorrow);
  }

  @override
  Future<WeekTaskModel> getWeek() async {
    final today = DateTime.now();
    var startFilter = DateTime(today.year, today.month, today.day, 0, 0, 0);
    DateTime endFilter;

    if (startFilter.weekday != DateTime.monday) {
      startFilter = startFilter.subtract(
        Duration(days: (startFilter.weekday - 1)),
      );
    }

    endFilter = startFilter.add(const Duration(days: 7));

    final tasks = await _tasksRepository.findByPeriod(startFilter, endFilter);
    return WeekTaskModel(
      startDate: startFilter,
      endDate: endFilter,
      tasks: tasks,
    );
  }

  @override
  Future<void> checkOrUncheckTask(TaskModel model) =>
      _tasksRepository.checkOrUncheckTask(model);

  @override
  Future<void> deleteTask(int id) => _tasksRepository.deleteTask(id);
}
