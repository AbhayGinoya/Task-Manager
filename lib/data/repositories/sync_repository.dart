import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/core/utils/constant.dart';
import 'package:task_manager/domain/database/local_database.dart';

class SyncRepository {
  final LocalDatabase _localDb;

  SyncRepository(this._localDb);

  /// Sync Local To Server
  Future<void> syncLocalToServer() async {
    try {
      List<TaskData> unSyncTask = await _localDb.getUnsyncTasks();
      if (unSyncTask.isNotEmpty) {
        for (TaskData element in unSyncTask) {
          final taskRef = FirebaseFirestore.instance.collection(Const.taskCollection).doc();
          Map<String, dynamic> taskMap = element.toJson();
          taskMap['serverId'] = taskRef.id;
          taskRef.set(taskMap);
          _localDb.updateTask(id: element.id, tasks: TaskCompanion(serverId: Value(taskRef.id)));
        }
      }
    }catch (e) {
      print("error: $e");
    }
  }

  /// Sync Server To Local
  Future<void> syncServerToLocal() async {
    QuerySnapshot<Map<String, dynamic>> serverTaskData = await FirebaseFirestore.instance
        .collection(Const.taskCollection)
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    List<DocumentSnapshot> snapshotData = [];
    snapshotData.addAll(serverTaskData.docs);

    List<TaskCompanion> tasks = snapshotData.map((e) {
      return TaskCompanion(
        serverId: e['serverId'],
        title: e['title'],
        description: e['description'],
        status: e['status'],
        date: e['date'],
      );
    }).toList();
    await _localDb.bulkInsert(tasks: tasks);
  }

  /// Sync Update Task
  Future<void> updateTask({required String serverId}) async {
    TaskData? task = await _localDb.getTaskByServerId(serverId: serverId);
    if (task != null) {
      final taskRef =FirebaseFirestore.instance.collection(Const.taskCollection).doc(serverId);
      Map<String, dynamic> taskMap = task.toJson();
      taskRef.set(taskMap);
    }
  }


  /// Sync Delete Task
  Future<void> deleteTask({required String serverId}) async {
      await FirebaseFirestore.instance.collection(Const.taskCollection).doc(serverId).delete();
  }
}
