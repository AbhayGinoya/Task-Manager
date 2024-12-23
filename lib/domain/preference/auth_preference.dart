
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/domain/preference/base_preference.dart';

class AuthPreference extends BasePreference {
  static const String prefName = "auth_preference";
  static const String isRememberMe = "is_remember_me";
  static const String userEmail = "user_email";
  static const String userPassword = "user_password";
  static const String firebaseToken = "firebase_token";
  static const String userName = "user_name";
  static const String userProfile = "user_profile";

  AuthPreference() : super(prefName);


  /// Save Is Remember me
  Future<void> saveIsRememberMe(bool isRemember) async =>
      await super.saveData(key: isRememberMe, value: isRemember.toString());

  /// Check Is Remember Me Or Not
  /// If Is True Whenever User Log Out Fill Email and Password Automatic
  /// else Set Empty Value in Email and Password
  Future<bool> checkIsRememberMe() async => (bool.tryParse(await super.readData(key: isRememberMe) ?? "") ?? false);

  /// Save User Email
  Future<void> saveUserEmail(String email) async => await super.saveData(key: userEmail, value: email);

  /// Get User Email
  Future<String> getUserEmail() async => await super.readData(key: userEmail) ?? "";

  /// Save User Password
  Future<void> saveUserPassword(String email) async => await super.saveData(key: userPassword, value: email);

  /// Get User Password
  Future<String> getUserPassword() async => await super.readData(key: userPassword) ?? "";


  /// Save User Profile
  Future<void> saveUserProfile(User user) async =>
      await super.saveData(key: userProfile, value: jsonEncode(user));

  /// Get User Profile
  Future<User> getUserProfile() async => jsonDecode((await super.readData(key: userProfile) ?? ""));

  /// Get UserId
  Future<String?> getUserId() async => (await getUserProfile()).uid;

  /// Save Firebase Token
  Future<void> saveFirebaseToken(String accessToken) async => await super.saveData(key: firebaseToken, value: accessToken);

  /// Get Firebase Token
  Future<String> getFirebaseToken() async => await super.readData(key: firebaseToken) ?? "";


}
