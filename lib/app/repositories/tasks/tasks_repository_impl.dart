import './tasks_repository.dart';
import '../../core/database/sqlite_connection_factory.dart';

class TasksRepositoryImpl implements TasksRepository {
  final SqliteConnectionFactory _sqliteConnectionFactory;

  TasksRepositoryImpl({
    required SqliteConnectionFactory sqliteConnectionFactory,
  }) : _sqliteConnectionFactory = sqliteConnectionFactory;

  @override
  Future<void> save(DateTime date, String description) async {
    try {
      final conn = await _sqliteConnectionFactory.openConnection();
      await conn.insert(
        'todo',
        {
          'id': null,
          'descricao': description,
          'data_hora': date.toIso8601String(),
          'finalizado': 0,
        },
      );
    } catch (e) {}
  }
}
