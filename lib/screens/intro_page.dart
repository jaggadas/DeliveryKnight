import 'package:delivery_knight_restaurant/constants/constants.dart';
import 'package:delivery_knight_restaurant/elements/standardbutton.dart';
import 'package:delivery_knight_restaurant/screens/login_page.dart';
import 'package:delivery_knight_restaurant/screens/registration_page.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  static const id = "LoginPage";
  const IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment:MainAxisAlignment.center ,
            crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
          Image(image: kLogoImage),
          StandardButton(text: 'Log In', onPressed: () {
            Navigator.pushNamed(context, LoginPage.id);
          }),
          SizedBox(height: 15,),
          StandardButton(text: 'Register', onPressed: () {Navigator.pushNamed(context, RegistrationPage.id);})
      ],
    ),
        ));
  }
}
