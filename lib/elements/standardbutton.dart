import 'package:flutter/material.dart';

import '../constants.dart';
class StandardButton extends StatelessWidget {
  VoidCallback onPressed;
  String text;
  StandardButton({required this.text,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 50,
      onPressed:onPressed,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)),
      color: kPrimaryColor,
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
    );
  }
}