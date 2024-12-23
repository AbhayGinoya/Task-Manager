import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/core/utils/constant.dart';
import 'package:task_manager/data/models/result.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Login with email and password
  Future<Result<User?>> login({required String email, required String password}) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Success(data: result.user);
    } on FirebaseAuthException catch (e) {
      return Error(message: e.message ?? "Something went wrong");
    } catch (e) {
      return Error(message: e.toString());
    }
  }

  /// create account with email and password
  Future<Result<User?>> register({required String email, required String password}) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      FirebaseFirestore.instance.collection(Const.userCollection).doc(result.user?.uid).set({
        "id": result.user?.uid,
        "name": result.user?.displayName,
        "email": email,
        "password": password,
        "date": DateTime.now(),
      });

      return Success(data: result.user);
    } on FirebaseAuthException catch (e) {
      return Error(message: e.message ?? "Something went wrong");
    } catch (e) {
      return Error(message: e.toString());
    }
  }

  /// Reset Password using Email
  Future<Result<String>> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email,actionCodeSettings: ActionCodeSettings(url: "https://task-manger-7610f.firebaseapp.com/__/auth/action?mode=action&oobCode=code"));
      return const Success(data: "Password reset mail send to your email.");
    } on FirebaseAuthException catch (e) {
      return Error(message: e.message ?? "Something went wrong");
    } catch (e) {
      return Error(message: e.toString());
    }
  }

  /// Reset Password using Email
  Future<Result<String>> changeEmail({required String email, required String password}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if(user != null) {

        /// Re-authenticate the user
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );

        await user.reauthenticateWithCredential(credential);

        /// Update the email
        await user.verifyBeforeUpdateEmail(email,ActionCodeSettings(url: "https://task-manger-7610f.firebaseapp.com/__/auth/action?mode=action&oobCode=code"));
        return const Success(data: "New email updated successfully");
      }

      return const Error(message: "Something went wrong");
    } on FirebaseAuthException catch (e) {
      return Error(message: e.message ?? "Something went wrong");
    } catch (e) {
      return Error(message: e.toString());
    }
  }


  /// Log Out
  Future<Result<String>> logOut() async {
    try {
      await _auth.signOut();
      return const Success(data: "Logout successfully");
    }on FirebaseAuthException catch (e) {
      return Error(message: e.message ?? "Something went wrong");
    } catch (e) {
      return Error(message: e.toString());
    }
  }
}
