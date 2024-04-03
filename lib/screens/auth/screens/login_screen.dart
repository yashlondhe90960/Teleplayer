import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teleplay/components/common_button.dart';
import 'package:teleplay/components/common_text_field.dart';
import 'package:teleplay/screens/auth/controller/auth_controller.dart';
import 'package:teleplay/screens/auth/screens/register_screen.dart';
import 'package:teleplay/screens/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  saveUserInfo(String jwt) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("email", emailcontroller.text);
      prefs.setString("password", passwordcontroller.text);
      prefs.setString("jwt", jwt);
    });
  }

  checkCredentials() async {
    var email = emailcontroller.text;
    var password = passwordcontroller.text;

    if (emailcontroller.text.isEmpty || passwordcontroller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all the fields"),
        ),
      );
      return;
    }
    if (emailcontroller.text.length < 6 || !email.contains("@")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter valid email"),
        ),
      );
      return;
    }
    if (passwordcontroller.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password must be at least 6 characters"),
        ),
      );
      return;
    } else {
      showCupertinoModalPopup(
          barrierDismissible: false,
          context: context,
          builder: (context) => Center(
                  child: CupertinoActivityIndicator(
                color: Colors.blue[800],
              )));
      login();
      Navigator.of(context).pop();
    }
  }

  void login() async {
    var email = emailcontroller.text;
    var password = passwordcontroller.text;

    var response = await AuthController().login(email, password);
    print(response);

    if (response == 'User does not exists') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid credentials"),
        ),
      );
    }
    if (response == 'email or passowrd is incorrect') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Check email or password again"),
        ),
      );
    } else {
      saveUserInfo(jsonDecode(response)['token']);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      body: Stack(children: [
        Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/teleplay_logo.png',
                  height: 250,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Enter your credentials to login",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 30,
                ),
                CommonTextField(hintText: "Email", controller: emailcontroller),
                const SizedBox(
                  height: 5,
                ),
                CommonTextField(
                  hintText: "Password",
                  controller: passwordcontroller,
                  isObscureText: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                CommonButton(
                  title: "Login",
                  onPressed: () {
                    checkCredentials();
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.blue),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()));
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
