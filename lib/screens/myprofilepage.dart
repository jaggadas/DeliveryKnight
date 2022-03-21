import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliveryknight/elements/standardbutton.dart';
import 'package:deliveryknight/models/Users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';


import '../constants.dart';

class MyProfile extends StatefulWidget {
  static const id = 'myprofile';
  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  FirebaseAuth auth=FirebaseAuth.instance;
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  Users currentUser=Users(name: 'name', phone: 'phone', regNo: 'regNo');
  var nameC=TextEditingController();
  var phoneC=TextEditingController();
  var regNoC=TextEditingController();
  getUserData()async{
    var userData =await firestore.collection("users").doc(auth.currentUser?.uid).get();
    print(userData.get('phone'));
    setState(() {
      currentUser=Users( phone: userData.get('phone'), regNo: userData.get('regNo'), name: userData.get('name'));
    });


  }
  setUserData(){
    nameC.text=currentUser.name;
    phoneC.text=currentUser.phone;
    regNoC.text=currentUser.regNo;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }
  @override
  Widget build(BuildContext context) {
    setUserData();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        title: Text("Profile Details",style: TextStyle(color: kBackground),),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
        ),
      ),
      body: Stack(
        children: [
          // ClipPath(clipper:
          // RoundedDiagonalPathClipper(),child: Container(color: kPrimaryColor,height: 250,),),
          ClipPath(clipper:
          DiagonalPathClipperTwo(),child: Container(color: kPrimaryColor,height: 400,),),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: kBackground,
                    elevation: 10,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: kBackground,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [

                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: nameC,
                            keyboardType: TextInputType.name,
                            enabled: false,
                            style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
                            decoration: kTextFieldInputDecoration.copyWith(
                                hintText: "Enter name",
                                fillColor: kBackground,
                                icon: Icon(
                                  Icons.person,
                                  color: kPrimaryColor,
                                )),
                            onChanged: (value) {

                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            enabled: false,
                            controller: regNoC,

                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
                            decoration: kTextFieldInputDecoration.copyWith(
                                hintText: "Enter registration number",
                                fillColor: kBackground,
                                icon: Icon(
                                  Icons.app_registration,
                                  color: kPrimaryColor,
                                )),
                            onChanged: (value) {

                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(

                            enabled: false,
                            controller: phoneC,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
                            decoration: kTextFieldInputDecoration.copyWith(
                                hintText: "Enter phone number",
                                fillColor: kBackground,
                                icon: Icon(
                                  Icons.phone,
                                  color: kPrimaryColor,
                                )),
                            onChanged: (value) {

                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

