import 'package:deliveryknight/authservice/authservice.dart';
import 'package:deliveryknight/screens/ItemSelect.dart';
import 'package:deliveryknight/screens/cart_screen.dart';
import 'package:deliveryknight/screens/homepage.dart';
import 'package:deliveryknight/screens/interstitialpage.dart';
import 'package:deliveryknight/screens/login_page.dart';
import 'package:deliveryknight/screens/myprofilepage.dart';
import 'package:deliveryknight/screens/userdetailspage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
 class MyApp extends StatelessWidget {
   const MyApp({Key? key}) : super(key: key);

   @override
   Widget build(BuildContext context) {
     return MaterialApp(
     //   initialRoute: LoginPage.id,
     routes: {
       LoginPage.id:(context){return LoginPage();},
       HomePage.id:(context){return HomePage();},
       UserDetails.id:(context){return UserDetails();},
       Interstitial.id:(context){return Interstitial();},
       MyProfile.id:(context){return MyProfile();},
       CartScreen.id:(context){return CartScreen();}

     },
     home: AuthService().handleAuth(),);
   }
 }