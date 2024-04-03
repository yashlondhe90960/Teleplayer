import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  CommonTextField(
      {super.key,
      required this.hintText,
      this.isObscureText = false,
      this.keyboardType = TextInputType.text,
      required this.controller});
  final String hintText;
  final bool isObscureText;
  TextInputType keyboardType = TextInputType.text;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        obscureText: isObscureText,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
