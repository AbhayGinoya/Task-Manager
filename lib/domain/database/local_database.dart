import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_manager/core/utils/enum.dart';
import 'dart:io';
import 'package:task_manager/data/models/task_model.dart';

part 'local_database.g.dart';

@DriftDatabase(tables: [Task])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  Future<List<TaskData>> getAllTasks({required Status status}) {
    if (status == Status.all) {
      return (select(task)..orderBy([(t) => OrderingTerm(expression: t.date,mode: OrderingMode.desc)])).get();
    } else {
      return (select(task)
            ..where((tbl) => tbl.status.equals(status.toString()))
            ..orderBy([(t) => OrderingTerm(expression: t.date,mode: OrderingMode.desc)]))
          .get();
    }
  }

  Future<List<TaskData>> getUnsyncTasks() {
    return (select(task)
          ..where((tbl) => tbl.serverId.equalsNullable(null))
          ..orderBy([(t) => OrderingTerm(expression: t.date)]))
        .get();
  }

  Future<int> insertTask({required TaskCompanion tasks}) => into(task).insert(tasks);

  Future<int> updateTask({required int id, required TaskCompanion tasks}) =>
      (update(task)..where((tbl) => tbl.id.equals(id))).write(tasks);

  Future<void> bulkInsert({required List<TaskCompanion> tasks}) async {
    for (TaskCompanion element in tasks) {
      /// Check if task with the given serverId exists
      final existingTask =
          await (select(task)..where((tbl) => tbl.serverId.equals((element.serverId.value!)))).getSingleOrNull();

      if (existingTask != null) {
        /// If the task exists, update it
        await (update(task)
          ..where((tbl) => tbl.serverId.equals(element.serverId.value!)))
        .write(element);

    } else {
        /// If the task doesn't exist, insert a new one
        await into(task).insert(element,mode: InsertMode.insertOrReplace);
      }
    }
  }

  Future<TaskData?> getTaskByServerId({required String serverId}) async {
    final query = select(task)
      ..where((task) => task.serverId.equals(serverId));

    return await query.getSingleOrNull();
  }

  Future<int> updateStatus({required int id, required Status status}) =>
      (update(task)..where((tbl) => tbl.id.equals(id))).write(TaskCompanion(
        status: Value(status.toString()),
      ));

  Future<int> deleteTask({required int id}) => (delete(task)..where((tbl) => tbl.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File('${dbFolder.path}/task_manager.sqlite');
    return NativeDatabase(file);
  });
}
