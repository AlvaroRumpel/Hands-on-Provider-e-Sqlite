import 'dart:developer';

import '../../core/notifier/default_change_notifier.dart';
import '../../services/tasks/tasks_service.dart';

class TaskCreateController extends DefaultChangeNotifier {
  final TasksService _tasksService;
  DateTime? _selectedDate;

  TaskCreateController({required TasksService tasksService})
      : _tasksService = tasksService;

  set selectedDate(DateTime? selectedDate) {
    resetState();
    _selectedDate = selectedDate;
    notifyListeners();
  }

  DateTime? get selectedDate => _selectedDate;

  Future<void> save(String description) async {
    try {
      showLoadingAndResetState();
      notifyListeners();

      if (selectedDate != null) {
        await _tasksService.save(selectedDate!, description);
        success();
      } else {
        setError('Data da Task não selecionada');
      }
    } catch (e, s) {
      log('Erro ao salvar a task', error: e, stackTrace: s);
      setError('Erro ao cadastrar a task');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
