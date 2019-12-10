import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  final storage = new FlutterSecureStorage();

  Future<void> delete({String key}) async {
    storage.delete(key: key);
  }

  Future<String> read({String key}) async {
    return storage.read(key: key);
  }

  Future<void> write({String key, String value}) async {
    storage.write(key: key, value: value);
  }

  Future<void> clear({String key}) async {
    storage.delete(key: key);
  }
}
