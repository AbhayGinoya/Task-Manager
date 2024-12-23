import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';
import 'package:task_manager/data/models/pair.dart';
import 'package:task_manager/data/models/result.dart';
import 'package:task_manager/data/repositories/auth_repository.dart';
import 'package:task_manager/providers/provider.dart';

class AuthProvider extends StateNotifier<User?> {
  final AuthRepository authRepository;

  AuthProvider(this.authRepository) : super(FirebaseAuth.instance.currentUser);

  Future<Pair<bool, String>> login({required String email, required String password}) async {
    Result<User?> result = await authRepository.login(email: email, password: password);
    switch (result) {
      case Success<User?> success:
        state = success.data;
        return Pair(true, "Login successfully");
      case Error<User?> error:
        return Pair(false, error.message);
    }
  }

  Future<Pair<bool, String>> register({required String email, required String password}) async {
    Result<User?> result = await authRepository.register(email: email, password: password);
    switch (result) {
      case Success<User?> success:
        state = success.data;
        return Pair(true, "Registration successfully");
      case Error<User?> error:
        return Pair(false, error.message);
    }
  }

  Future<Pair<bool, String>> forgotPassword({required String email}) async {
    Result<String> result = await authRepository.resetPassword(email: email);
    switch (result) {
      case Success<String> success:
        return Pair(true, success.data);
      case Error<String?> error:
        return Pair(false, error.message);
    }
  }

  Future<Pair<bool, String>> updateEmail({required String email, required String password}) async {
    Result<String> result = await authRepository.changeEmail(email: email,password: password);
    switch (result) {
      case Success<String> success:
        return Pair(true, success.data);
      case Error<String?> error:
        return Pair(false, error.message);
    }
  }

  Future<Pair<bool, String>> logout() async {
    Result<String> result =  await authRepository.logOut();
    switch (result) {
      case Success<String> success:
        return Pair(true, success.data);
      case Error<String?> error:
        return Pair(false, error.message);
    }
  }
}

final authProvider = StateNotifierProvider<AuthProvider, User?>((ref) => AuthProvider(ref.read(authRepository)));
