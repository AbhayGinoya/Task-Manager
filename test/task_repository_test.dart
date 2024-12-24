import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_manager/core/utils/enum.dart';
import 'package:task_manager/core/utils/extension.dart';
import 'package:task_manager/data/repositories/task_repository.dart';
import 'package:task_manager/domain/database/local_database.dart';

import 'mock.mocks.dart';


void main() {
  group('TaskRepository', () {
    late MockLocalDatabase mockLocalDb;
    late TaskRepository taskRepository;

    setUp(() {
      mockLocalDb = MockLocalDatabase();
      taskRepository = TaskRepository(mockLocalDb);
    });



    /***
     * Add Task Method Test Case
     */
    test('addTask (insertTask) method', () async {

      const userId = '123';
      const title = 'Test Task';
      const description = 'Description';
      DateTime date =  DateTime.now().formatDate(DateFormats.YYYY_MM_DD_HH_MM_SS).convertStringToDate(DateFormats.YYYY_MM_DD_HH_MM_SS);

      when(mockLocalDb.insertTask(
        tasks: anyNamed('tasks'),  // Use anyNamed to match the 'tasks' argument
      )).thenAnswer((_) async => 1);  // Return ID 1 for inserted task


      await taskRepository.addTask(userId: userId, title: title, description: description, date: date);

      verify(mockLocalDb.insertTask(
        tasks: TaskCompanion(
          userId: const Value(userId),
          title: const Value(title),
          description: const Value(description),
          date:  Value(date),
          status: Value(Status.pending.toString()),
        ),
      )).called(1);
    });


    /***
     * Get All Task Method Test Case
     */
    test('getLocalTask should return a list of tasks', () async {

      const status = Status.pending;
      final taskList = [
        TaskData(
            id: 1,
            title: 'Test Task',
            status: status.toString(),
            date: DateTime.now().formatDate(DateFormats.YYYY_MM_DD_HH_MM_SS).convertStringToDate(DateFormats.YYYY_MM_DD_HH_MM_SS),
            userId: '1',
            description: 'Test Description')
      ];

      when(mockLocalDb.insertTask(
        tasks: anyNamed('tasks'),
      )).thenAnswer((_) async => 1);

      when(mockLocalDb.getAllTasks(status: status)).thenAnswer((_) async => taskList);


      final result = await taskRepository.getLocalTask(status: status);


      expect(result, taskList);
      verify(mockLocalDb.getAllTasks(status: status)).called(1);
    });

    /***
     * Update Task Method Test Case
     */

    test('updateTask  method', () async {
      const id = 1;
      const title = 'Updated Task';
      const description = 'Updated Description';

      // Mock updateTask method to return a Future<int> (rows affected)
      when(mockLocalDb.updateTask(
        id: anyNamed('id'),
        tasks: anyNamed('tasks'),
      )).thenAnswer((_) async => 1);  // Return 1 to indicate that 1 row is affected

      await taskRepository.updateTask(id: id, title: title, description: description);

      verify(mockLocalDb.updateTask(
        id: id,
        tasks: TaskCompanion(
          title: const Value(title),
          description: const Value(description),
          date: Value( DateTime.now().formatDate(DateFormats.YYYY_MM_DD_HH_MM_SS).convertStringToDate(DateFormats.YYYY_MM_DD_HH_MM_SS),),
        ),
      )).called(1);
    });


    /***
     * Delete Task Method Test Case
     */
    test('deleteTask method', () async {
      const id = 1;
      when(mockLocalDb.deleteTask(id: id)).thenAnswer((_) async => 1);  // Return 1 for 1 row deleted

      await taskRepository.deleteTask(id: id);

      verify(mockLocalDb.deleteTask(id: id)).called(1);
    });

    /***
     * Update Task Status Method Test Case
     */
    test('updateTaskStatus method', () async {
      const id = 1;
      const status = Status.completed;

      when(mockLocalDb.updateStatus(id: id, status: status)).thenAnswer((_) async => 1);  // Return 1 for 1 row deleted


      await taskRepository.updateTaskStatus(id: id, status: status);
      verify(mockLocalDb.updateStatus(id: id, status: status)).called(1);
    });
  });
}
