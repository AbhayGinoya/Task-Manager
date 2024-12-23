import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/core/utils/enum.dart';
import 'package:task_manager/data/repositories/auth_repository.dart';
import 'package:task_manager/data/repositories/task_repository.dart';
import 'package:task_manager/domain/database/local_database.dart';
import 'package:task_manager/domain/entities/task_entity.dart';
import 'package:task_manager/providers/status_provider.dart';
import 'package:task_manager/providers/task_provider.dart';

final localDbProvider = Provider((_) => LocalDatabase());

final taskRepositoryProvider = Provider((ref) =>
   TaskRepository(ref.read(localDbProvider)));

final authRepository = Provider((ref) => AuthRepository());

/*
final taskProvider =
StateNotifierProvider<TaskProvider, List<TaskEntity>>((ref) => TaskProvider(ref.read(taskRepositoryProvider)));
*/

final taskProvider = StateNotifierProvider<TaskProvider, List<TaskEntity>>(
      (ref) => TaskProvider(ref.read(taskRepositoryProvider), ref),
);

final statusProvider = StateNotifierProvider<StatusNotifier, Status>((ref) {
  return StatusNotifier();
});