import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';
import 'package:task_manager/core/utils/enum.dart';
import 'package:task_manager/core/utils/extension.dart';
import 'package:task_manager/data/repositories/task_repository.dart';
import 'package:task_manager/domain/database/local_database.dart';
import 'package:task_manager/domain/entities/task_entity.dart';
import 'package:task_manager/domain/use_case/sync_manger.dart';
import 'package:task_manager/providers/provider.dart';

class TaskProvider extends StateNotifier<List<TaskEntity>> {
  final TaskRepository repository;
  final Ref ref;

  // TaskProvider(this.repository) : super([]);

  TaskProvider(this.repository, this.ref) : super([]) {
    ref.listen<Status>(statusProvider, (_, next) {
      loadAllTask(status: next);
      _status = next;
    });
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Status _status = Status.all;

  Future<void> loadAllTask({Status status = Status.all}) async {
    _isLoading = true;
    final List<TaskData> localItems = await repository.getLocalTask(status: status);
    state = localItems
        .map((item) => TaskEntity(
              id: item.id,
              serverId: item.serverId,
              userId: item.userId,
              title: item.title,
              description: item.description,
              status: item.status,
              date: item.date,
            ))
        .toList();
    _isLoading = false;
  }

  Future<void> updateStatus({String? serverId, required int id, required Status status}) async {
    await repository.updateTaskStatus(id: id, status: status);
    loadAllTask(status: _status);

    ///Server is not null or empty than call update sync
    ///Other wise call local to server
    ///because if server id is null or empty that means this task is current not available in firebase
    ///That's why we call local to server sync instead of update sync
    if (serverId != null && serverId.isNotEmpty) {
      SyncManager.updateLocalToServer(serverId: serverId);
    } else {
      SyncManager.syncLocalToServer();
    }
  }

  Future<void> deleteTask(int id, {String? serverId}) async {
    await repository.deleteTask(id: id);
    state = state.where((item) => item.id != id).toList();

    /// Call sync only if task is save in firebase other wise no required to call sync
    if (serverId != null && serverId.isNotEmpty) {
      SyncManager.updateLocalToServer(serverId: serverId);
    }
  }

  Future<void> createTask({required String title, required String description}) async {
    await repository.addTask(
        userId: FirebaseAuth.instance.currentUser?.uid ?? "",
        title: title,
        description: description,
        date: DateTime.now().formatDate(DateFormats.YYYY_MM_DD_HH_MM_SS).convertStringToDate(DateFormats.YYYY_MM_DD_HH_MM_SS));
    await loadAllTask(status: _status);
    SyncManager.syncLocalToServer();
  }

  Future<void> updateTask(
      {String? serverId, required int taskId, required String title, required String description}) async {
    await repository.updateTask(
      id: taskId,
      title: title,
      description: description,
    );
    await loadAllTask(status: _status);

    ///Server is not null or empty than call update sync
    ///Other wise call local to server
    ///because if server id is null or empty that means this task is current not available in firebase
    ///That's why we call local to server sync instead of update sync
    if (serverId != null && serverId.isNotEmpty) {
      SyncManager.updateLocalToServer(serverId: serverId);
    } else {
      SyncManager.syncLocalToServer();
    }
  }
}
