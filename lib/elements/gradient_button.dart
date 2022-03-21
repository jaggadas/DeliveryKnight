import 'dart:ffi';

import 'package:deliveryknight/constants.dart';
import 'package:flutter/material.dart';



class GradientButton extends StatelessWidget {
  String title;
  final VoidCallback onPressed;
GradientButton({Key? key, required this.title,required this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      onPressed: onPressed,
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20,left: 40),
            width: double.infinity,

            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: Text(title,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),)),
            ),
            decoration:  ShapeDecoration(

              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              gradient:
              LinearGradient(colors: [kPrimaryColor,kPrimaryColor]),
            ),
          ),
        ],
      ),
    );
  }
}
