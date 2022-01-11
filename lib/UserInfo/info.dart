import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_task_app/UserInfo/user.dart';
import 'package:flutter_task_app/signup+login/login.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test User Info")),
      body: Center(
        child: Column(
          children: [
            Text("Name: " + User.name!),
            Text("Email: " + User.email!),
            ElevatedButton(
                onPressed: () {
                  while (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                  const storage = FlutterSecureStorage();
                  storage.deleteAll();
                },
                child: const Text("Logout"))
          ],
        ),
      ),
    );
  }
}
