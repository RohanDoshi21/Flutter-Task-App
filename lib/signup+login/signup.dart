import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_task_app/Urls/urls.dart';
import 'package:flutter_task_app/UserInfo/info.dart';
import 'package:flutter_task_app/UserInfo/user.dart';
import 'package:flutter_task_app/signup+login/login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final storage = const FlutterSecureStorage();
  bool load = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future createUser() async {
    if (_name.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Name cannot be empty!',
        backgroundColor: Colors.blue.shade600,
      );
      setState(() {
        load = false;
      });
      return;
    }
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
        "name": _name.text.trim(),
        "email": _email.text.trim(),
        "password": _password.text.trim()
      };
      final response = await http.post(
        Uri.parse(createUserUrl),
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 201) {
        var result = jsonDecode(response.body);
        await storage.write(key: 'token', value: result['token']);
        await storage.write(key: 'name', value: _name.text.trim());
        await storage.write(key: 'email', value: _email.text.trim());
        await getData();
        setState(() {
          load = false;
        });
        Fluttertoast.showToast(
          msg: 'Sign-up Successful',
          backgroundColor: Colors.blue.shade600,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserInfo()),
        );
      } else {
        setState(() {
          load = false;
        });
        var result = jsonDecode(response.body);
        var msg = result['message'] ??
            "Error in signing-up try with a different email";
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
                      height: MediaQuery.of(context).size.height * 0.62,
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
                              "Sign Up",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 35),
                            ),
                            SizedBox(
                              height: size.height * 0.025,
                            ),
                            const Text(
                              "Welcome! Its nice to see you join our team!",
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
                                      controller: _name,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(.9),
                                      ),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.account_circle_outlined,
                                          color: Colors.white.withOpacity(.8),
                                        ),
                                        border: InputBorder.none,
                                        hintMaxLines: 1,
                                        hintText: "Name",
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
                                          "Sign Up",
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
                                      await createUser();
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
                          "Already have an account? ",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        InkWell(
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
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
