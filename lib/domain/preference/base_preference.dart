
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BasePreference {
  String preferenceName;

  BasePreference(this.preferenceName);

  /// Android Configuration
  AndroidOptions _getAndroidOptions() => AndroidOptions(
      encryptedSharedPreferences: true,
      sharedPreferencesName: preferenceName,
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding);

  /// Ios  Configuration
  IOSOptions _getIosOptions() =>
      IOSOptions(accessibility: KeychainAccessibility.first_unlock, accountName: preferenceName);

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// For Save A Data
  @mustCallSuper
  Future<void> saveData({required String key, required String value}) async {
    return await _storage.write(key: key, value: value, aOptions: _getAndroidOptions(), iOptions: _getIosOptions());
  }

  /// For Read A Data
  @mustCallSuper
  Future<String?> readData({required String key}) async {
    return await _storage.read(key: key, aOptions: _getAndroidOptions(), iOptions: _getIosOptions());
  }

  /// For Delete A Single Data
  @mustCallSuper
  Future<void> delete({required String key}) async {
    return await _storage.delete(key: key, aOptions: _getAndroidOptions(), iOptions: _getIosOptions());
  }

  /// Clear Storage
  @mustCallSuper
  Future<void> clearStorage() async {
    return await _storage.deleteAll(aOptions: _getAndroidOptions(), iOptions: _getIosOptions());
  }
}
