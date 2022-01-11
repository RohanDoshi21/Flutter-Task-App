import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_task_app/UserInfo/info.dart';
import 'package:flutter_task_app/UserInfo/user.dart';
import 'package:flutter_task_app/signup+login/login.dart';
import 'package:flutter_task_app/signup+login/signup.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: User.name == null ? const SignUpPage() : const UserInfo(),
    );
  }
}
