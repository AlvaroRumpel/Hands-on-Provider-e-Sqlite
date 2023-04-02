import '../../core/notifier/default_change_notifier.dart';
import '../../models/task_filter_enum.dart';
import '../../models/task_model.dart';
import '../../models/total_tasks_model.dart';
import '../../models/week_task_model.dart';
import '../../services/tasks/tasks_service.dart';

class HomeController extends DefaultChangeNotifier {
  final TasksService _tasksService;
  var filterSelected = TaskFilterEnum.today;
  TotalTasksModel? todayTotalTasks;
  TotalTasksModel? tomorrowTotalTasks;
  TotalTasksModel? weekTotalTasks;
  List<TaskModel> allTasks = [];
  List<TaskModel> filteredTasks = [];
  DateTime? initialDateWeek;
  DateTime? selectedDay;
  var showFinishedTask = false;

  HomeController({required TasksService tasksService})
      : _tasksService = tasksService;

  Future<void> loadTotalTasks() async {
    final allTasks = await Future.wait(
      [
        _tasksService.getToday(),
        _tasksService.getTomorrow(),
        _tasksService.getWeek(),
      ],
    );

    final todayTasks = allTasks[0] as List<TaskModel>;
    final tomorrowTasks = allTasks[1] as List<TaskModel>;
    final weekTasks = allTasks[2] as WeekTaskModel;

    todayTotalTasks = TotalTasksModel(
      totalTasks: todayTasks.length,
      totalTasksFinish: todayTasks.where((element) => element.finished).length,
    );

    tomorrowTotalTasks = TotalTasksModel(
      totalTasks: tomorrowTasks.length,
      totalTasksFinish:
          tomorrowTasks.where((element) => element.finished).length,
    );

    weekTotalTasks = TotalTasksModel(
      totalTasks: weekTasks.tasks.length,
      totalTasksFinish:
          weekTasks.tasks.where((element) => element.finished).length,
    );

    notifyListeners();
  }

  Future<void> findTasks({required TaskFilterEnum filter}) async {
    filterSelected = filter;
    showLoading();
    notifyListeners();
    List<TaskModel> tasks;

    switch (filter) {
      case TaskFilterEnum.today:
        tasks = await _tasksService.getToday();
        break;
      case TaskFilterEnum.tomorrow:
        tasks = await _tasksService.getTomorrow();
        break;
      case TaskFilterEnum.week:
        final weekModel = await _tasksService.getWeek();
        initialDateWeek = weekModel.startDate;
        tasks = weekModel.tasks;
        break;
    }

    filteredTasks = tasks;
    allTasks = tasks;

    if (filter == TaskFilterEnum.week) {
      if (selectedDay != null) {
        filterByDay(selectedDay!);
      } else if (initialDateWeek != null) {
        filterByDay(initialDateWeek!);
      }
    } else {
      selectedDay = null;
    }

    if (!showFinishedTask) {
      filteredTasks =
          filteredTasks.where((element) => !element.finished).toList();
    }

    hideLoading();
    notifyListeners();
  }

  void filterByDay(DateTime date) {
    selectedDay = date;
    filteredTasks = allTasks
        .where(
          (element) => element.dateTime == selectedDay,
        )
        .toList();
    notifyListeners();
  }

  Future<void> refreshPage() async {
    await findTasks(filter: filterSelected);
    await loadTotalTasks();
    notifyListeners();
  }

  Future<void> checkOrUncheckTask(TaskModel taskModel) async {
    showLoadingAndResetState();
    notifyListeners();

    final taskUpdate = taskModel.copyWith(finished: !taskModel.finished);
    await _tasksService.checkOrUncheckTask(taskUpdate);

    hideLoading();
    refreshPage();
  }

  void showOrHideFinishedTasks() {
    showFinishedTask = !showFinishedTask;
    refreshPage();
  }

  Future<void> deleteTask(int id) async {
    await _tasksService.deleteTask(id);
    refreshPage();
  }
}
