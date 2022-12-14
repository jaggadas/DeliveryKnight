import 'package:flutter/material.dart';
int _primaryColor=0xffcb202d;
int _primaryColorTransparent=0x99cb202d;
Color kPrimaryColor= Color(_primaryColor);
Color kPrimaryColorTransparent= Color(_primaryColorTransparent);
Color kBackground=const Color(0xffF9F9F9);
Color kBackgroundAccent=const Color(0xffFFFFFF);
Color kTextColor=const Color(0xff333333);
Color kTextColorTransparent=const Color(0x99333333);
AssetImage kBgImageLogin=const AssetImage("assets/splash.png");
AssetImage kLogoImage=const AssetImage("assets/logo.png");
Color kTransparentColor=const Color(0x99FFFFFF);
var kCartTextStyle=const TextStyle(fontSize: 18);
InputDecoration kTextFieldInputDecoration=const InputDecoration(
  filled: true,
  fillColor: Color(0xffFFFFFF),
  border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(10))),
  hintText: 'Enter phone number',
  hintStyle: TextStyle(color: Colors.grey,fontSize: 18),
  icon: Icon(
    Icons.phone,
    size: 24,
    color:Color(0xffEE2B29),
  ),
);
var kTextInputDecoration=InputDecoration(
hintText: 'Enter OTP',
contentPadding:
const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
border: const OutlineInputBorder(
borderRadius: BorderRadius.all(Radius.circular(10.0)),
),
enabledBorder: OutlineInputBorder(
borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
borderRadius: const BorderRadius.all(Radius.circular(10.0)),
),
focusedBorder: OutlineInputBorder(
borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
borderRadius: const BorderRadius.all(Radius.circular(10.0)),
),);
var kGrey=const Color(0xff323233);
