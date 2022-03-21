import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliveryknight/screens/homepage.dart';
import 'package:deliveryknight/screens/interstitialpage.dart';
import 'package:deliveryknight/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService{

  handleAuth(){
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context,snapshot) {
        if(snapshot.hasData){
          return Interstitial();
        }
        else{

          return LoginPage();
        }
      },
    );
  }
  signOut(BuildContext context){
    FirebaseAuth.instance.signOut();
    handleAuth();
    Navigator.popAndPushNamed(context, LoginPage.id);
  }
  signIn(AuthCredential authCredential,context)async{
    try{
    await FirebaseAuth.instance.signInWithCredential(authCredential);
    Navigator.pushNamed(context, Interstitial.id);
    }
        catch(e){
          Fluttertoast.showToast(
              msg: "$e",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }

  }
  signInWithOTP(smsCode, verId,BuildContext context) {
    try{
    AuthCredential authCreds = PhoneAuthProvider.credential(
        verificationId: verId, smsCode: smsCode);
    signIn(authCreds,context);}
    catch(e){
     print(e);
    }
    }
  }
