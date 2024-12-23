import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:mockito/annotations.dart';
import 'package:task_manager/domain/database/local_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';


@GenerateMocks([
  Firebase,
  FirebaseAuth,
  UserCredential,
  User,
  FirebaseFirestore,
  CollectionReference<Map<String, dynamic>>,
  DocumentReference<Map<String, dynamic>>,
  LocalDatabase,
  QuerySnapshot<Map<String, dynamic>>,
  DocumentSnapshot<Map<String, dynamic>>,
  QueryDocumentSnapshot<Map<String, dynamic>>
])



typedef Callback = void Function(MethodCall call);

void setupFirebaseAuthMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  setupFirebaseCoreMocks();
}

Future<T> neverEndingFuture<T>() async {
  // ignore: literal_only_boolean_expressions
  while (true) {
    await Future.delayed(const Duration(minutes: 5));
  }
}
