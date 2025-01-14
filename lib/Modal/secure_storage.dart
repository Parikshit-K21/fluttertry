import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = FlutterSecureStorage();

  // Save data
  Future<void> saveData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // Read data
  Future<String?> readData(String key) async {
    return await _storage.read(key: key);
  }

  // Delete specific key
  Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }

  // Clear all data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
