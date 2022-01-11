import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
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
                        style: TextStyle(color: Colors.white, fontSize: 35),
                      ),
                      SizedBox(
                        height: size.height * 0.025,
                      ),
                      const Text(
                        "Welcome! Its nice to see you join our team!",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      SizedBox(
                        height: size.height * 0.025,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: size.height * 0.08,
                              width: size.width / 1.25,
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(right: size.width / 30),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextField(
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
                              padding: EdgeInsets.only(right: size.width / 30),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextField(
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
                              padding: EdgeInsets.only(right: size.width / 30),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextField(
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
                                child: Center(
                                  child: Text(
                                    "Sign Up",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24),
                                  ),
                                ),
                              ),
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
                      Navigator.pop(context);
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
