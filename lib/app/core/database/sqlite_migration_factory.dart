import 'package:todo_list_provider/app/core/database/migrations/migration.dart';
import 'package:todo_list_provider/app/core/database/migrations/migration_v1.dart';

class SqliteMigrationFactory {
  List<Migration> getCreateMigration() => [
        MigrationV1(),
      ];

  List<Migration> getUpgradeMigration(int version) {
    var migrations = <Migration>[];

    // if (version == 1) {
    //   migrations.add(MigrationV2());
    // }

    return migrations;
  }
}
