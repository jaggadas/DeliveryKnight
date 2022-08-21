import 'package:delivery_knight_restaurant/constants/constants.dart';
import 'package:delivery_knight_restaurant/screens/AddItem.dart';
import 'package:delivery_knight_restaurant/screens/intro_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const id = "home";
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushNamed(context, AddItem.id);
      },child: Icon(Icons.add),backgroundColor: kPrimaryColor,),
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: FlatButton(
          child: Icon(Icons.logout,color: Colors.white,),
          onPressed: () {
            _auth.signOut();
            Navigator.popAndPushNamed(context,IntroPage.id);
          },
        ),
      ),
      body: Container(
        child: Center(child: Text('Sign Out')),
      ),
    );
  }
}
