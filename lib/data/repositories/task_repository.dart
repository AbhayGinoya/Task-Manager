import 'package:drift/drift.dart';
import 'package:task_manager/core/utils/enum.dart';
import 'package:task_manager/core/utils/extension.dart';
import 'package:task_manager/domain/database/local_database.dart';

class TaskRepository {
  final LocalDatabase _localDb;

  TaskRepository(this._localDb);

  /// Get all items from Drift
  Future<List<TaskData>> getLocalTask({required Status status}) => _localDb.getAllTasks(status: status);

  /// Add task to drift database
  Future<void> addTask({
    required String userId,
    required String title,
    required String description,
    required DateTime date,
  }) async {
    await _localDb.insertTask(
        tasks: TaskCompanion(
      userId: Value(userId),
      title: Value(title),
      description: Value(description),
      date: Value(date),
      status: Value(Status.pending.toString()),
    ));
  }

  /// Update task to drift database
  Future<void> updateTask({
    required int id,
    required String title,
    required String description,
  }) async {
    await _localDb.updateTask(
        id: id,
        tasks: TaskCompanion(
          title: Value(title),
          description: Value(description),
          date: Value(DateTime.now().formatDate(DateFormats.YYYY_MM_DD_HH_MM_SS).convertStringToDate(DateFormats.YYYY_MM_DD_HH_MM_SS)),
        ));
  }

  /// Delete task  drift
  Future<void> deleteTask({required int id}) async {
    await _localDb.deleteTask(id: id);
  }

  /// Update task to drift
  Future<void> updateTaskStatus({required int id, required Status status}) async {
    await _localDb.updateStatus(id: id, status: status);
  }
}
