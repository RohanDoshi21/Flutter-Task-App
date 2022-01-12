import 'package:flutter/material.dart';
import 'UserInfo/user.dart';
import 'home/home.dart';
import 'signup+login/signup.dart';

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
      home: User.name == null ? const SignUpPage() : const HomePage(),
    );
  }
}
