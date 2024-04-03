import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teleplay/components/common_button.dart';
import 'package:teleplay/components/common_text_field.dart';
import 'package:teleplay/screens/auth/controller/auth_controller.dart';
import 'package:teleplay/screens/home/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  saveUserInfo(String jwt) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("email", emailController.text);
      prefs.setString("password", passwordController.text);
      prefs.setString("name", nameController.text);
      prefs.setString("jwt", jwt);
    });
  }

  checkCredentials() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all the fields"),
        ),
      );
      return;
    }
    if (emailController.text.length < 6 ||
        !emailController.text.contains("@")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter valid email"),
        ),
      );
      return;
    }
    if (passwordController.text.length < 6) {
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
      register();
      Navigator.of(context).pop();
    }
  }

  void register() async {
    var response = await AuthController().register(
        emailController.text, passwordController.text, nameController.text);

    print(response);
    if (response == "Email Already Exists") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
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
                  height: 200,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Register as a new user",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 30,
                ),
                CommonTextField(hintText: "Name", controller: nameController),
                CommonTextField(hintText: "Email", controller: emailController),
                CommonTextField(
                  hintText: "Password",
                  controller: passwordController,
                  isObscureText: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                CommonButton(
                  title: "Register",
                  onPressed: () {
                    checkCredentials();
                  },
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
