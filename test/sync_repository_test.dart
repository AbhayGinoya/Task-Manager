import 'package:drift/drift.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_manager/core/utils/constant.dart';
import 'package:task_manager/data/repositories/sync_repository.dart';
import 'package:task_manager/domain/database/local_database.dart';
import 'mock.dart';
import 'mock.mocks.dart';



void main() {
  /// TestWidgetsFlutterBinding.ensureInitialized();
  /// Gets called in setupFirebaseAuthMocks()
  setupFirebaseAuthMocks();

  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFirebaseFirestore mockFirestore;
  late MockLocalDatabase mockLocalDb;
  late SyncRepository syncRepository;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockCollectionReference<Map<String, dynamic>> mockTaskCollection;
  late MockDocumentReference<Map<String, dynamic>> mockTaskDoc;

  setUp(() async {
    /// Firebase Initialize
    await Firebase.initializeApp();

    /// Local Variable Initialize
    mockFirestore = MockFirebaseFirestore();
    mockLocalDb = MockLocalDatabase();
    mockTaskCollection = MockCollectionReference<Map<String, dynamic>>();
    mockTaskDoc = MockDocumentReference<Map<String, dynamic>>();
    mockFirebaseAuth = MockFirebaseAuth();


    when(mockFirebaseAuth.currentUser).thenReturn(MockUser());

    syncRepository = SyncRepository(mockLocalDb);
    when(mockFirestore.collection(Const.taskCollection)).thenReturn(mockTaskCollection);
    when(mockTaskCollection.doc()).thenReturn(mockTaskDoc); // Ensure doc() returns mockTaskDoc
    when(mockTaskDoc.id).thenReturn('serverTaskId'); // Mock the ID returned by the document reference

    // Stub the updateTask method to return a Future<int>
    when(mockLocalDb.updateTask(id: anyNamed("id"), tasks: anyNamed("tasks"))).thenAnswer((_) async => 1); // Return 1 to indicate success (can be adjusted)

    // Mock getUnsyncTasks method to return a list of tasks
    final tasks = [
      const TaskData(id: 1, title: 'Task 1', description: 'Desc', status: 'Pending', date: '2024-12-23', userId: '1'),
    ];
    when(mockLocalDb.getUnsyncTasks()).thenAnswer((_) async => tasks);

  });

  group("Sync Repository Test", () {
    /***
     * Sync Local To Server Test Case
     */
    test('syncLocalToServer - should sync local tasks to the server', () async {
      // Call syncLocalToServer
      await syncRepository.syncLocalToServer();

      // Assert that the methods were called the expected number of times
      verify(mockLocalDb.getUnsyncTasks()).called(1); // Verify getUnsyncTasks was called once
      verify(mockTaskCollection.doc()).called(1); // Verify doc() was called once to create the document reference
      verify(mockTaskDoc.set(any)).called(1); // Verify the set method was called on the document reference

      // Ensure the updateTask method is called with the correct arguments
      verify(mockLocalDb.updateTask(
        id: 1,
        tasks: argThat(
          isA<TaskCompanion>().having((t) => t.serverId.value, 'serverId', 'serverTaskId'),
          named: 'tasks', // Correct use of named argument matcher
        ),
      )).called(1); // Verify updateTask is called once with the correct task
    });


    /****
     * Sync Local To Server Test Case
     */
    test('syncServerToLocal - should sync server tasks to local database', () async {
      /// Get data from server
      final mockQueryDocSnapshot = MockQueryDocumentSnapshot<Map<String, dynamic>>();
      when(mockQueryDocSnapshot.data()).thenReturn({
        'serverId': '123',
        'title': 'Task 1',
        'description': 'Desc',
        'status': 'Pending',
        'date': '2024-12-23',
      });

      final mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
      when(mockQuerySnapshot.docs).thenReturn([mockQueryDocSnapshot]);
      when(mockTaskCollection.where('userId', isEqualTo: anyNamed('isEqualTo'))).thenReturn(mockTaskCollection);
      when(mockTaskCollection.get()).thenAnswer((_) async => mockQuerySnapshot);

      /// Call sync server to local
      await syncRepository.syncServerToLocal();

      verify(mockTaskCollection.where('userId', isEqualTo: anyNamed('isEqualTo'))).called(1);
      verify(mockTaskCollection.get()).called(1);
      verify(mockLocalDb.bulkInsert(tasks: anyNamed('tasks'))).called(1);
    });

    /***
     * Update Task Test Case
     */
    test('updateTask - should update task on the server', () async {
      // Stub the updateTask method with Future<void>
      when(mockLocalDb.updateTask(
        id: anyNamed('id'),
        tasks: anyNamed('tasks'),
      )).thenAnswer((_) async {
        // Return a Future<void> since updateTask is an async void method
        return Future.value();
      });

      // Test your SyncRepository logic
      final syncRepository = SyncRepository(mockLocalDb);

      // Create TaskCompanion instance as per the structure
      const taskCompanion = TaskCompanion(
        id: Value(1),
        serverId: Value('12'),
        userId: Value("1"),
        title: Value("Update Task"),
        status: Value("Open"),
        description: Value("Task Update test Case"),
        date: Value("23-12-2024 8:30 pm"),
      );

      // Call the syncLocalToServer method that will invoke updateTask
      await syncRepository.syncLocalToServer();

      // Verify that updateTask was called with the correct arguments
      verify(mockLocalDb.updateTask(
        id: 1,
        tasks: argThat(
          equals(taskCompanion), // Match exact TaskCompanion
          named: 'tasks',
        ), // Ensure we pass the correct TaskCompanion
      )).called(1);
    });

    /***
     * Delete Task Test Case
     */
    test('deleteTask - should delete task from the server', () async {
      /// Delete task
      await syncRepository.deleteTask(serverId: '123');
      verify(mockTaskCollection.doc('123')).called(1);
      verify(mockTaskDoc.delete()).called(1);
    });
  });


}
