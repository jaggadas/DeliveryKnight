import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_knight_restaurant/constants/constants.dart';
import 'package:delivery_knight_restaurant/elements/standardbutton.dart';
import 'package:delivery_knight_restaurant/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationPage extends StatefulWidget {
  static const id = "registrationPage";
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late String enteredEmail;
  late String enteredPassword;
  late String enteredName;
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  bool validateForm() {
    if (email.text.isEmpty || password.text.isEmpty || name.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('Register'),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(image: kBgImageLogin, fit: BoxFit.cover),
            ),
          ),
          // Image(image:kLogoImage,height: 250,width: 250,),
          ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: kTransparentColor,
                    elevation: 10,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: kTransparentColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Let\'s get started',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: kTextColor, fontSize: 30),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: name,
                            keyboardType: TextInputType.name,
                            style: TextStyle(color: Colors.black),
                            decoration: kTextFieldInputDecoration.copyWith(
                                icon: Icon(
                                  Icons.restaurant_menu,
                                  color: kPrimaryColor,
                                ),
                                hintText: "Enter restaurant name"),
                            onChanged: (value) {
                              enteredName = value;
                            },
                          ),
                          SizedBox(height: 10,),
                          TextField(
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.black),
                            decoration: kTextFieldInputDecoration.copyWith(
                                icon: Icon(
                                  Icons.email,
                                  color: kPrimaryColor,
                                ),
                                hintText: "Enter email"),
                            onChanged: (value) {
                              enteredEmail = value;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: password,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            style: TextStyle(color: Colors.black),
                            decoration: kTextFieldInputDecoration.copyWith(
                                icon: Icon(
                                  Icons.password,
                                  color: kPrimaryColor,
                                ),
                                hintText: "Enter password"),
                            onChanged: (value) {
                              enteredPassword = value;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          StandardButton(
                              text: 'Register',
                              onPressed: () async {
                                if (validateForm()) {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  try {
                                    final loggedInUser = await _auth
                                        .createUserWithEmailAndPassword(
                                            email: enteredEmail,
                                            password: enteredPassword);

                                    await firestore.collection('Restaurant').doc(_auth.currentUser?.uid).set(
                                        {'restaurantName': enteredName});

                                    if (loggedInUser != null) {
                                      Navigator.popAndPushNamed(context, HomePage.id);
                                      setState(() {
                                        showSpinner = false;
                                      });
                                    }
                                  } catch (e) {
                                    print(e);
                                    setState(() {
                                      showSpinner = false;
                                    });
                                   Fluttertoast.showToast(
                                        msg:"$e",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    backgroundColor: kPrimaryColor,
                                    content: const Text(
                                      "Invalid input",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ));
                                }
                              })
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
