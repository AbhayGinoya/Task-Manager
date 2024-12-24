import 'package:firebase_core/firebase_core.dart';
import 'package:task_manager/data/repositories/sync_repository.dart';
import 'package:task_manager/domain/database/local_database.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await Firebase.initializeApp();
    if (task == SyncManager.saveDataTag) {
      await SyncRepository(LocalDatabase()).syncLocalToServer();
    } else if (task == SyncManager.getDataTag) {
      await SyncRepository(LocalDatabase()).syncServerToLocal();
    } else if (task == SyncManager.updateDataTag && inputData != null) {
      await SyncRepository(LocalDatabase()).updateTask(serverId: inputData["serverId"]);
    } else if (task == SyncManager.deleteDataTag && inputData != null) {
      await SyncRepository(LocalDatabase()).deleteTask(serverId: inputData["serverId"]);
    }
    return Future.value(true);
  });
}

abstract final class SyncManager {
  static const String saveDataTag = "save_data";
  static const String getDataTag = "get_data";
  static const String updateDataTag = "update_data";
  static const String deleteDataTag = "delete_data";

  SyncManager._();

  static Future<void> syncLocalToServer() async {
    Workmanager().registerOneOffTask(saveDataTag, saveDataTag,
        tag: saveDataTag,
        initialDelay: const Duration(seconds: 10),
        backoffPolicy: BackoffPolicy.exponential,
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
        existingWorkPolicy: ExistingWorkPolicy.replace);
  }

  static Future<void> syncServerToLocal() async {
    Workmanager().registerOneOffTask(getDataTag, getDataTag,
        tag: getDataTag,
        backoffPolicy: BackoffPolicy.exponential,
        initialDelay: const Duration(seconds: 10),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
        existingWorkPolicy: ExistingWorkPolicy.replace);
  }

  static Future<void> updateLocalToServer({required String serverId}) async {
    Workmanager().registerOneOffTask(updateDataTag, updateDataTag,
        tag: updateDataTag,
        initialDelay: const Duration(seconds: 10),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
        existingWorkPolicy: ExistingWorkPolicy.append,
        inputData: {"serverId": serverId});
  }

  static Future<void> deleteLocalToServer({required String serverId}) async {
    Workmanager().registerOneOffTask(deleteDataTag, deleteDataTag,
        tag: deleteDataTag,
        initialDelay: const Duration(seconds: 10),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
        existingWorkPolicy: ExistingWorkPolicy.append,
        inputData: {"serverId": serverId});
  }
}
