import 'package:delivery_knight_restaurant/screens/AddItem.dart';
import 'package:delivery_knight_restaurant/screens/home.dart';
import 'package:delivery_knight_restaurant/screens/intro_page.dart';
import 'package:delivery_knight_restaurant/screens/login_page.dart';
import 'package:delivery_knight_restaurant/screens/registration_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}
class MyApp extends StatelessWidget {
  final auth=FirebaseAuth.instance;
  var currentUser;
  getCurrentUser(){
    currentUser=auth.currentUser;
  }
  @override
  Widget build(BuildContext context) {
    getCurrentUser();
    return MaterialApp(
      theme: ThemeData.light(),
      home: currentUser!=null? HomePage(): IntroPage(),
      routes: {
        IntroPage.id:(context){return IntroPage();},
        LoginPage.id:(context){return LoginPage();},
        RegistrationPage.id:(context){return RegistrationPage();},
        HomePage.id :(context){return HomePage();},
        AddItem.id:(context){return AddItem();}


      },
    );
  }
}
