import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliveryknight/authservice/authservice.dart';
import 'package:deliveryknight/elements/standardbutton.dart';
import 'package:deliveryknight/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants.dart';

class UserDetails extends StatefulWidget {
  static const id = "UserDetails";
  const UserDetails({Key? key}) : super(key: key);

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  late String entered_regno;
  late String entered_name;

  final textName = TextEditingController();
  final textRegNo = TextEditingController();
  FirebaseAuth auth=FirebaseAuth.instance;
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("DeliveryKnight"),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          leading: FlatButton(onPressed: () { AuthService().signOut(context); }, child: Icon(Icons.logout,color: Colors.white,),),

        ),
        body: Stack(children: [
          ClipPath(clipper:
          DiagonalPathClipperTwo(),child: Container(color: kPrimaryColor,height: 400,),),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                      color: Colors.white,
                  elevation: 10,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Enter details',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: kTextColor, fontSize: 30),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: textName,
                          keyboardType: TextInputType.name,
                          style: TextStyle(color: Colors.black),
                          decoration: kTextFieldInputDecoration.copyWith(

                              hintText: "Enter name",
                              icon: Icon(
                                Icons.person,
                                color: kPrimaryColor,
                              )),
                          onChanged: (value) {
                            entered_name = value;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: textRegNo,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.black),
                          decoration: kTextFieldInputDecoration.copyWith(
                              hintText: "Enter registration number",
                              icon: Icon(
                                Icons.app_registration,
                                color: kPrimaryColor,
                              )),
                          onChanged: (value) {
                            entered_regno = value;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        StandardButton(
                          text: 'Submit',
                          onPressed: () async {
                            if(textName.text.isEmpty||textRegNo.text.isEmpty){
                                Fluttertoast.showToast(
                                msg: "Please enter valid details",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                                }else{
                              await firestore.collection('users').doc(auth.currentUser?.uid).set(
                              {'name': entered_name, 'phone': '${auth.currentUser?.phoneNumber}','regNo':entered_regno});
                              Navigator.popAndPushNamed(context, HomePage.id);
                            }
                            }
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}
