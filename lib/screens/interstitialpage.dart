import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliveryknight/constants.dart';
import 'package:deliveryknight/screens/homepage.dart';
import 'package:deliveryknight/screens/userdetailspage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
class Interstitial extends StatefulWidget {
  static const id='interstitial';
  const Interstitial({Key? key}) : super(key: key);

  @override
  _InterstitialState createState() => _InterstitialState();
}

class _InterstitialState extends State<Interstitial> {
  FirebaseAuth auth=FirebaseAuth.instance;
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  nextPage()async{
    var userData =await firestore.collection("users").doc(auth.currentUser?.uid).get();

    if(userData.exists){

      Navigator.popAndPushNamed(context,HomePage.id);
    }else{

      Navigator.popAndPushNamed(context, UserDetails.id);}
  }
  @override

  void initState(){
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    nextPage();
    return Scaffold(backgroundColor: kPrimaryColor,body: const Center(child: SpinKitRotatingCircle(color: Colors.orangeAccent,size: 100,),),);
  }
}
