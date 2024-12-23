import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task_manager/data/models/result.dart';
import 'package:task_manager/data/repositories/auth_repository.dart';
import 'mock.dart';
import 'mock.mocks.dart';


void main() {
  late AuthRepository authRepository;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;
  late MockUserCredential mockUserCredential;

  setUpAll(() async {
    // Mock Firebase.initializeApp to avoid actual Firebase initialization
    TestWidgetsFlutterBinding.ensureInitialized();
    setupFirebaseAuthMocks();
    await Firebase.initializeApp();
  });

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();
    authRepository = AuthRepository();  // Initialize with mockFirebaseAuth
  });

  group('AuthRepository', () {

    test('Register successfully with valid credentials', () async {
    when(mockFirebaseAuth.createUserWithEmailAndPassword(
      email: 'newuser@example.com',
      password: 'password123',
    )).thenAnswer((_) async => mockUserCredential);

    when(mockUserCredential.user).thenReturn(mockUser);

    final result = await authRepository.register(
      email: 'newuser@example.com',
      password: 'password123',
    );

    expect(result, isA<Success<User?>>());
    expect((result as Success<User?>).data, mockUser);
  });




  test('Login successfully with valid credentials', () async {
        when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'Test@123',
        )).thenAnswer((_) async => mockUserCredential);

        when(mockUserCredential.user).thenReturn(mockUser);

        final result = await authRepository.login(
          email: 'test@example.com',
          password: 'Test@123',
        );

        expect(result, isA<Success<User?>>());
        expect((result as Success<User?>).data, mockUser);
      });

    test('should return error if login fails due to incorrect credentials', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'wrongpassword',
      )).thenThrow(FirebaseAuthException(
        code: 'wrong-password',
        message: 'Wrong password.',
      ));

      final result = await authRepository.login(
        email: 'test@example.com',
        password: 'wrongpassword',
      );

      expect(result, isA<Error>());
      expect((result as Error).message, 'Wrong password.');
    });


    test('should reset password successfully', () async {
      when(mockFirebaseAuth.sendPasswordResetEmail(email: 'test@example.com'))
          .thenAnswer((_) async {});

      final result = await authRepository.resetPassword(
        email: 'test@example.com',
      );

      expect(result, isA<Success<String>>());
      expect((result as Success<String>).data, 'Password reset mail send to your email.');
    });

    test('should change email successfully', () async {
      final authCredential = EmailAuthProvider.credential(
        email: 'test@example.com',
        password: 'password123',
      );

      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.reauthenticateWithCredential(authCredential))
          .thenAnswer((_) async => mockUserCredential);
      final actionCodeSettings = ActionCodeSettings(
        url: "https://task-manger-7610f.firebaseapp.com/__/auth/action?mode=action&oobCode=code",
      );

      when(mockUser.verifyBeforeUpdateEmail("test@gmail.com",actionCodeSettings)).thenAnswer((_) async {});

      final result = await authRepository.changeEmail(
        email: 'newemail@example.com',
        password: 'password123',
      );

      expect(result, isA<Success<String>>());
      expect((result as Success<String>).data, 'New email updated successfully');
    });

    test('Logout successfully', () async {
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async => null);

      final result = await authRepository.logOut();

      expect(result, isA<Success<String>>());
      expect((result as Success<String>).data, 'Logout successfully');

      verify(mockFirebaseAuth.signOut()).called(1);

    });
  });
}
