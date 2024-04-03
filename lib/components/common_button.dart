import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({super.key, required this.title, required this.onPressed});
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          )),
          minimumSize: MaterialStateProperty.all(const Size(280, 50)),
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.white)),
      onPressed: onPressed,
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.blue, fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }
}
