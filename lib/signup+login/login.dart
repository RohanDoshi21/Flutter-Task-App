import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_task_app/Urls/urls.dart';
import 'package:flutter_task_app/UserInfo/user.dart';
import 'package:flutter_task_app/home/home.dart';
import 'package:flutter_task_app/signup+login/signup.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final storage = const FlutterSecureStorage();
  bool load = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future loginUser() async {
    if (_email.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Email cannot be empty!',
        backgroundColor: Colors.blue.shade600,
      );
      setState(() {
        load = false;
      });
      return;
    }
    if (_password.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Password cannot be empty!',
        backgroundColor: Colors.blue.shade600,
      );
      setState(() {
        load = false;
      });
      return;
    }
    try {
      Map data = {
        "email": _email.text.trim(),
        "password": _password.text.trim()
      };
      final response = await http.post(
        Uri.parse(loginUrl),
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        await storage.write(key: 'token', value: result['token']);
        await storage.write(key: 'email', value: _email.text.trim());
        await storage.write(key: 'name', value: result['user']['name']);
        await storage.write(key: 'id', value: result['user']['_id']);
        await getData();
        // print(result['user']['name']);
        setState(() {
          load = false;
        });
        Fluttertoast.showToast(
          msg: 'Login-in Successful',
          backgroundColor: Colors.blue.shade600,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        setState(() {
          load = false;
        });
        var result = jsonDecode(response.body);
        var msg = result['message'] ?? "Error in login-in";
        Fluttertoast.showToast(
          msg: msg,
          backgroundColor: Colors.blue.shade600,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Please try again later',
        backgroundColor: Colors.blue.shade600,
      );
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: load
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/bgimage.jpg"),
                    fit: BoxFit.cover),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.05,
                            ),
                            const Text(
                              "Login",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 35),
                            ),
                            SizedBox(
                              height: size.height * 0.025,
                            ),
                            const Text(
                              "Welcome Back! Its nice to see you back!",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            SizedBox(
                              height: size.height * 0.025,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: size.height * 0.08,
                                    width: size.width / 1.25,
                                    alignment: Alignment.center,
                                    padding:
                                        EdgeInsets.only(right: size.width / 30),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: TextField(
                                      controller: _email,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(.9),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.email_outlined,
                                          color: Colors.white.withOpacity(.8),
                                        ),
                                        border: InputBorder.none,
                                        hintMaxLines: 1,
                                        hintText: "email",
                                        hintStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white.withOpacity(.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.025,
                                  ),
                                  Container(
                                    height: size.height * 0.08,
                                    width: size.width / 1.25,
                                    alignment: Alignment.center,
                                    padding:
                                        EdgeInsets.only(right: size.width / 30),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: TextField(
                                      controller: _password,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(.9),
                                      ),
                                      keyboardType: TextInputType.text,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.lock_outline_rounded,
                                          color: Colors.white.withOpacity(.8),
                                        ),
                                        border: InputBorder.none,
                                        hintMaxLines: 1,
                                        hintText: "Password",
                                        hintStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white.withOpacity(.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.025,
                                  ),
                                  InkWell(
                                    child: Container(
                                      height: size.height * 0.06,
                                      width: size.width * 0.30,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Login",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24),
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      setState(() {
                                        load = false;
                                      });
                                      await loginUser();
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.050,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Do not have an account? ",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        InkWell(
                          child: const Text(
                            "Signup",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
