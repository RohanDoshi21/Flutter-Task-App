import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class User {
  static String? name;
  static String? token;
  static String? email;
}

Future getData() async {
  const storage = FlutterSecureStorage();
  User.name = await storage.read(key: 'name');
  User.token = await storage.read(key: 'token');
  User.email = await storage.read(key: 'email');
  return;
}
